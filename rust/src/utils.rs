use std::{
    ffi::OsString,
    fs::{create_dir_all, remove_dir_all, remove_file, File},
    io::{copy, Cursor, Read, Result, Seek, Write},
    os::windows::ffi::{OsStrExt, OsStringExt},
    path::{Path, PathBuf},
    ptr::null_mut,
    slice::from_raw_parts,
    sync::mpsc,
    thread,
    time::Duration,
};

use windows::{
    core::{HSTRING, PCWSTR, Interface},
    Win32::{
        System::Com::{
            CoCreateInstance, CoInitializeEx, CoTaskMemFree, CoUninitialize, IPersistFile,
            CLSCTX_INPROC_SERVER, COINIT_APARTMENTTHREADED,
        },
        UI::Shell::{
            FOLDERID_Desktop, IShellLinkW, SHGetKnownFolderPath, ShellLink, KF_FLAG_DEFAULT,
        },
    },
};
use zip::ZipArchive;

use crate::InstallMessage;

pub fn create_data_files(path: PathBuf, content: &str, tx: &mpsc::Sender<InstallMessage>) -> bool {
    let _ = tx.send(InstallMessage::Status(format!(
        "Creating file: {}",
        path.display()
    )));

    match File::create(&path) {
        Ok(mut file) => {
            if let Err(e) = file.write_all(content.as_bytes()) {
                let _ = tx.send(InstallMessage::Error(format!(
                    "Failed to write to file {}: {}",
                    path.display(),
                    e
                )));
                return false;
            }
        }
        Err(e) => {
            let _ = tx.send(InstallMessage::Error(format!(
                "Failed to create file {}: {}",
                path.display(),
                e
            )));
            return false;
        }
    };
    true
}

pub fn prepare_directory(
    simba_dir: &PathBuf,
    tx: &mpsc::Sender<InstallMessage>,
    current_progress: &mut f32,
    weight: f32,
    start_progress: f32,
) -> bool {
    let subfolders = ["Data", "Fonts", "Includes", "Scripts"];

    if simba_dir.exists() {
        let _ = tx.send(InstallMessage::Status(format!(
            "Cleaning up previous installation in: {}",
            simba_dir.display()
        )));
        thread::sleep(Duration::from_secs(1));
        if let Err(e) = remove_dir_all(simba_dir) {
            let _ = tx.send(InstallMessage::Error(format!(
                "Failed to remove existing directory: {}",
                e
            )));
            return false;
        }
        *current_progress = start_progress + (weight * 0.5);
        let _ = tx.send(InstallMessage::Progress(*current_progress));
    }

    let _ = tx.send(InstallMessage::Status(format!(
        "Creating installation directory: {}",
        simba_dir.display()
    )));
    thread::sleep(Duration::from_secs(1));
    if let Err(e) = create_dir_all(simba_dir) {
        let _ = tx.send(InstallMessage::Error(format!(
            "Failed to create directory: {}",
            e
        )));
        return false;
    }
    *current_progress = start_progress + weight;
    let _ = tx.send(InstallMessage::Progress(*current_progress));

    let mut data_folder_created = false;

    for folder_name in &subfolders {
        let sub_dir_path = simba_dir.join(folder_name);
        let _ = tx.send(InstallMessage::Status(format!(
            "Creating sub-directory: {}",
            sub_dir_path.display()
        )));
        thread::sleep(Duration::from_millis(100));
        if let Err(e) = create_dir_all(&sub_dir_path) {
            let _ = tx.send(InstallMessage::Error(format!(
                "Failed to create sub-directory {}: {}",
                sub_dir_path.display(),
                e
            )));
            return false;
        }

        if folder_name == &"Data" {
            data_folder_created = true;
        }
    }

    if data_folder_created {
        let path = simba_dir.join("Data").join("default.simba");
        let content = "(* Thank you for choosing waspscripts.com *)\n\n(* To start simply double click the green play button. *)\n\nbegin\n  SimbaRunInTab(ScriptPath + 'wasp-launcher.simba');\nend.\n";
        create_data_files(path, &content, tx);

        let path = simba_dir.join("Data").join("packages.ini");
        let install_dir = simba_dir.to_str().expect("Failed.");
        let content = format!(
            "[Torwent/SRL-T]\nName=SRL-T\nTemplates={}\\Includes\\SRL-T\\templates\n\n[Torwent/WaspLib]\nName=WaspLib\nTemplates={}\\Includes\\WaspLib\\templates\n",
            install_dir, install_dir,
        );
        create_data_files(path, &content, tx);
    } else {
        let _ = tx.send(InstallMessage::Error(
            "Internal error: 'Data' folder not created before attempting to write default.simba."
                .to_string(),
        ));
        return false;
    }

    true
}

fn get_desktop_path() -> Option<PathBuf> {
    unsafe {
        match SHGetKnownFolderPath(&FOLDERID_Desktop, KF_FLAG_DEFAULT, None) {
            Ok(pwstr) => {
                let mut len = 0;
                while *pwstr.0.add(len) != 0 {
                    len += 1;
                }

                let slice = from_raw_parts(pwstr.0, len as usize);
                let os_string = OsString::from_wide(slice);
                CoTaskMemFree(Some(pwstr.0 as *const _));

                Some(PathBuf::from(os_string))
            }
            Err(e) => {
                eprintln!("Failed to get Desktop path: {e}");
                None
            }
        }
    }
}

pub fn create_shortcut(target: &str, shortcut_name: &str, description: &str) -> bool {
    let desktop = match get_desktop_path() {
        Some(path) => path,
        None => {
            eprintln!("Could not get Desktop path.");
            return false;
        }
    };

    let shortcut_path = desktop.join(format!("{shortcut_name}.lnk"));

    if shortcut_path.exists() {
        if let Err(e) = remove_file(&shortcut_path) {
            eprintln!("Failed to remove existing shortcut: {e}");
            return false;
        }
    }

    unsafe {
        if CoInitializeEx(Some(null_mut()), COINIT_APARTMENTTHREADED).is_err() {
            eprintln!("Failed to initialize COM.");
            return false;
        }

        let result = (|| {
            let shell_link: IShellLinkW = CoCreateInstance(&ShellLink, None, CLSCTX_INPROC_SERVER)
                .map_err(|e| {
                    eprintln!("CoCreateInstance failed: {e}");
                })
                .ok()?;

            shell_link.SetPath(&HSTRING::from(target)).ok()?;
            shell_link
                .SetDescription(&HSTRING::from(description))
                .ok()?;

            let persist_file: IPersistFile = shell_link
                .cast()
                .map_err(|e| {
                    eprintln!("Failed to cast to IPersistFile: {e}");
                })
                .ok()?;

            let wide_path: Vec<u16> = shortcut_path
                .as_os_str()
                .encode_wide()
                .chain(Some(0))
                .collect();

            persist_file.Save(PCWSTR(wide_path.as_ptr()), true).ok()?;

            Some(())
        })();

        CoUninitialize();
        result.is_some()
    }
}

pub fn download_file(
    client: &reqwest::blocking::Client,
    url: &str,
    file_name: &str,
    simba_dir: &PathBuf,
    tx: &mpsc::Sender<InstallMessage>,
) -> bool {
    let _ = tx.send(InstallMessage::Status(format!(
        "Downloading {}...",
        file_name
    )));

    let response = match client.get(url).send() {
        Ok(res) => res,
        Err(e) => {
            let _ = tx.send(InstallMessage::Error(format!(
                "Failed to download {}: Network error: {}",
                file_name, e
            )));
            return false;
        }
    };

    let status = response.status();
    let headers = response.headers().clone();
    let body_bytes = match response.bytes() {
        Ok(bytes) => bytes,
        Err(e) => {
            eprintln!(
                "Failed to read response body for: {}, URL: {}, Status: {}",
                file_name, url, status
            );
            eprintln!("Headers:");
            for (key, value) in headers.iter() {
                eprintln!("  {}: {:?}", key, value);
            }
            eprintln!("Error reading body: {}", e);

            let _ = tx.send(InstallMessage::Error(format!(
                "Failed to read response body for {}: {}",
                file_name, e
            )));
            return false;
        }
    };

    let text = String::from_utf8_lossy(&body_bytes).to_string();

    if !status.is_success() {
        eprintln!(
            "Error downloading: {}, URL: {}, Status: {}",
            file_name, url, status
        );
        eprintln!("Headers:");
        for (key, value) in headers.iter() {
            eprintln!("  {}: {:?}", key, value);
        }
        eprintln!("Response Body (if available):{}", text);

        let _ = tx.send(InstallMessage::Error(format!(
            "Failed to download {}: HTTP status {} - {}",
            file_name,
            status,
            text.lines().next().unwrap_or("").trim()
        )));
        return false;
    }

    let file_path = simba_dir.join(file_name);
    let mut file = match File::create(&file_path) {
        Ok(f) => f,
        Err(e) => {
            let _ = tx.send(InstallMessage::Error(format!(
                "Failed to create file {}: {}",
                file_path.display(),
                e
            )));
            return false;
        }
    };

    let mut content_reader = Cursor::new(body_bytes);

    if let Err(e) = copy(&mut content_reader, &mut file) {
        let _ = tx.send(InstallMessage::Error(format!(
            "Failed to write content to {}: {}",
            file_path.display(),
            e
        )));
        return false;
    }

    true
}

pub fn download_launcher(
    client: &reqwest::blocking::Client,
    simba_dir: &PathBuf,
    tx: &mpsc::Sender<InstallMessage>,
    current_progress: &mut f32,
    weight: f32,
) -> bool {
    let path = simba_dir.join("Scripts");
    if !download_file(
        client,
        "https://raw.githubusercontent.com/Torwent/wasp-launcher/main/launcher.simba",
        "wasp-launcher.simba",
        &path,
        tx,
    ) {
        return false;
    }
    *current_progress += weight;
    let _ = tx.send(InstallMessage::Progress(*current_progress));

    true
}

pub fn unzip<R: Read + Seek>(reader: R, target_dir: &Path) -> Result<()> {
    let mut archive = ZipArchive::new(reader)?;

    for i in 0..archive.len() {
        let mut file = archive.by_index(i)?;
        let Some(path) = file.enclosed_name() else {
            continue;
        };

        let rel_path: PathBuf = path.components().skip(1).collect();
        let outpath = target_dir.join(rel_path);

        if file.name().ends_with('/') {
            create_dir_all(&outpath)?;
        } else {
            if let Some(parent) = outpath.parent() {
                create_dir_all(parent)?;
            }
            let mut outfile = File::create(&outpath)?;
            copy(&mut file, &mut outfile)?;
        }
    }
    Ok(())
}
