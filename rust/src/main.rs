#![windows_subsystem = "windows"]
use std::{
    env,
    fs::{remove_file, File},
    io::Cursor,
    path::{Path, PathBuf},
    process::Command,
    sync::mpsc,
    thread,
    time::Duration,
};

use eframe::{egui, NativeOptions};
use egui::{vec2, Align, Button, CentralPanel, Color32, IconData, Layout, ProgressBar, RichText};
use image::ImageReader;

mod utils;
use utils::{create_shortcut, download_file, download_launcher, prepare_directory, unzip};

pub enum InstallMessage {
    Progress(f32),
    Status(String),
    Completed,
    Error(String),
}

struct SimbaInstaller {
    page: u8,
    simba_dir: PathBuf,
    simba_exists: bool,
    install_progress: f32,
    is_installing: bool,
    installation_message: String,
    install_channel_rx: Option<mpsc::Receiver<InstallMessage>>,
    pub is_error_message: bool,
    run_simba: bool,
    silent: bool,
}

#[derive(serde::Deserialize)]
struct GitHubRelease {
    zipball_url: String,
}

fn download_simba_executable(
    client: &reqwest::blocking::Client,
    simba_dir: &PathBuf,
    tx: &mpsc::Sender<InstallMessage>,
    current_progress: &mut f32,
    weight: f32,
) -> bool {
    if !download_file(
        client,
        "https://github.com/Torwent/Simba/releases/latest/download/Simba-Win64.exe",
        "Simba64.exe",
        simba_dir,
        tx,
    ) {
        return false;
    }
    *current_progress += weight;
    let _ = tx.send(InstallMessage::Progress(*current_progress));
    true
}

fn download_github_release(
    client: &reqwest::blocking::Client,
    url: &str,
    local_file_name: &str,
    simba_dir: &PathBuf,
    tx: &mpsc::Sender<InstallMessage>,
    current_progress: &mut f32,
    weight: f32,
) -> bool {
    let repo = local_file_name.replace(".zip", "");
    let _ = tx.send(InstallMessage::Status(format!("Fetching {} release information...", repo)));

    let response = match client.get(url).send() {
        Ok(res) => res,
        Err(e) => {
            let _ = tx.send(InstallMessage::Error(format!(
                "Failed to send request for {} release info: {}", repo, e
            )));
            return false;
        }
    };

    let status = response.status();
    let body_bytes = match response.bytes() {
        Ok(bytes) => bytes,
        Err(e) => {
            let _ = tx.send(InstallMessage::Error(format!(
                "Failed to read response body for {} release info: {}", repo, e
            )));
            return false;
        }
    };
    let text = String::from_utf8_lossy(&body_bytes).to_string();

    if !status.is_success() {
        let _ = tx.send(InstallMessage::Error(format!(
            "{} release info HTTP error: HTTP status {} - {}",
            repo, status, text.lines().next().unwrap_or("").trim()
        )));
        return false;
    }

    let release: GitHubRelease = match serde_json::from_str::<GitHubRelease>(&text) {
        Ok(release) => release,
        Err(e) => {
            let _ = tx.send(InstallMessage::Error(format!(
                "Failed to parse {} release JSON: {}", repo, e
            )));
            return false;
        }
    };

    let start_progress = *current_progress;
    let weight_value = weight / 2.0;
    if !download_file(client, &release.zipball_url, local_file_name, simba_dir, tx) {
        return false;
    }
    *current_progress += weight_value;
    let _ = tx.send(InstallMessage::Progress(*current_progress));

    let _ = tx.send(InstallMessage::Status(format!("Unzipping {}...", repo)));

    let zip_path = simba_dir.join(local_file_name);
    let zip_file = match File::open(&zip_path) {
        Ok(file) => file,
        Err(e) => {
            let _ = tx.send(InstallMessage::Error(format!(
                "Failed to open downloaded zip for {}: {}", repo, e
            )));
            return false;
        }
    };

    let includes_repo_path = simba_dir.join("Includes").join(&repo);
    if let Err(e) = unzip(zip_file, &includes_repo_path) {
        let _ = tx.send(InstallMessage::Error(format!(
            "Failed to extract zip for {}: {}", repo, e
        )));
        return false;
    }

    let _ = remove_file(&zip_path);
    *current_progress = start_progress + weight;
    let _ = tx.send(InstallMessage::Progress(*current_progress));
    true
}

impl SimbaInstaller {
    fn new(_cc: &eframe::CreationContext<'_>, silent: bool) -> Self {
        let install_path = env::var("LOCALAPPDATA").expect("Could not get LOCALAPPDATA environment variable");
        let simba_dir = Path::new(&install_path).join("Simba");
        let simba_exists = simba_dir.exists() && simba_dir.is_dir();

        Self {
            page: 0,
            simba_dir,
            simba_exists,
            install_progress: 0.0,
            is_installing: false,
            installation_message: "Ready to install...".to_string(),
            install_channel_rx: None,
            is_error_message: false,
            run_simba: false,
            silent,
        }
    }

    fn show_welcome_page(&mut self, ui: &mut egui::Ui, width: f32, _height: f32) {
        ui.with_layout(Layout::top_down(Align::Center), |ui| {
            ui.allocate_ui_with_layout(
                vec2(width / 1.2, 120.0),
                Layout::top_down(Align::Center),
                |ui| {
                    ui.label("Welcome to WaspScripts Simba installer.\nTo begin the installation click Next.");
                    ui.add_space(10.0);
                    ui.label(format!("Install path is fixed to:\n{}", self.simba_dir.display()));
                },
            );
        });

        ui.with_layout(Layout::bottom_up(Align::RIGHT), |ui| {
            if ui.add_sized([100.0, 30.0], Button::new("Next")).clicked() {
                self.page += 1;
            }
        });
    }

    fn show_existing_install_warning_page(&mut self, ui: &mut egui::Ui) {
        if self.silent {
            self.page += 1;
            return;
        }

        if self.simba_exists {
            ui.with_layout(Layout::top_down(Align::Center), |ui| {
                ui.label(
                    "You seem to have a previous Simba installation.\nContinuing may result in loss of previous data.",
                );
                ui.allocate_ui_with_layout(
                    vec2(210.0, 120.0),
                    Layout::top_down(Align::Center),
                    |ui| {
                        ui.with_layout(Layout::left_to_right(Align::Center).with_main_wrap(false), |ui| {
                            if ui.add_sized([100.0, 30.0], Button::new("Cancel")).clicked() {
                                self.page -= 1;
                            }
                            if ui.add_sized([100.0, 30.0], Button::new("Continue")).clicked() {
                                self.page += 1;
                            }
                        });
                    },
                );
            });
            return;
        }
        self.page += 1;
    }

    fn show_version_selection_page(&mut self, ui: &mut egui::Ui) {
        ui.with_layout(Layout::top_down(Align::Center), |ui| {
            ui.label(
                "The installation might take a while.\n\nPlease don't close the installer midway to prevent corruption.",
            );
        });

        ui.with_layout(Layout::bottom_up(Align::RIGHT), |ui| {
            if ui.add_sized([100.0, 30.0], Button::new("Install")).clicked() {
                self.page += 1;
            }
        });
    }

    fn show_installation_page(&mut self, ui: &mut egui::Ui) {
        ui.with_layout(Layout::top_down(Align::Center), |ui| {
            ui.heading("Installation Progress");
            ui.add_space(20.0);

            if self.is_error_message {
                ui.label(RichText::new(&self.installation_message).color(Color32::RED).strong());
            } else {
                ui.label(&self.installation_message);
            }

            ui.add_space(10.0);
            ui.add_sized([400.0, 20.0], ProgressBar::new(self.install_progress).show_percentage());
            ui.add_space(20.0);

            if !self.is_installing && self.install_progress < 1.0 {
                self.is_installing = true;
                self.installation_message = "Starting installation process...".to_string();
                self.is_error_message = false;
                self.install_progress = 0.0;

                let (tx, rx) = mpsc::channel::<InstallMessage>();
                self.install_channel_rx = Some(rx);

                let simba_dir_for_thread = self.simba_dir.clone();
                let tx_for_thread = tx.clone();

                thread::spawn(move || {
                    SimbaInstaller::run_installation_thread(simba_dir_for_thread, tx_for_thread);
                });
            }

            if let Some(rx) = &self.install_channel_rx {
                while let Ok(msg) = rx.try_recv() {
                    match msg {
                        InstallMessage::Progress(p) => {
                            self.install_progress = p;
                            ui.ctx().request_repaint();
                        }
                        InstallMessage::Status(s) => {
                            self.installation_message = s;
                            self.is_error_message = false;
                            ui.ctx().request_repaint();
                        }
                        InstallMessage::Completed => {
                            self.install_progress = 1.0;
                            self.is_installing = false;
                            self.installation_message = "Installation successful!".to_string();
                            self.is_error_message = false;
                            self.page += 1;
                            ui.ctx().request_repaint();
                        }
                        InstallMessage::Error(e) => {
                            self.install_progress = 1.0;
                            self.is_installing = false;
                            self.installation_message = format!("Installation failed: {}", e);
                            self.is_error_message = true;
                            ui.ctx().request_repaint();
                        }
                    }
                }
            }
        });
    }

    fn run_installation_thread(simba_dir: PathBuf, tx: mpsc::Sender<InstallMessage>) {
        let client = reqwest::blocking::Client::builder()
            .user_agent("WaspScripts-Installer")
            .timeout(Duration::from_secs(300))
            .build()
            .expect("Failed to build reqwest client");

        let mut current_progress = 0.0;

        let initial_setup_weight = 0.05;
        let dir_prep_weight = 0.10;
        let simba_exe_download_weight = 0.15;
        let srl_t_download_weight = 0.3;
        let wasplib_download_weight = 0.3;
        let launcher_download_weight = 0.05;

        let _ = tx.send(InstallMessage::Status("Initializing installation process...".to_string()));
        thread::sleep(Duration::from_millis(200));
        current_progress += initial_setup_weight;
        let _ = tx.send(InstallMessage::Progress(current_progress));

        let dir_prep_start_progress = current_progress;
        if !prepare_directory(&simba_dir, &tx, &mut current_progress, dir_prep_weight, dir_prep_start_progress) {
            return;
        }

        let start_progress = current_progress;
        if !download_simba_executable(&client, &simba_dir, &tx, &mut current_progress, simba_exe_download_weight) {
            return;
        }
        current_progress = start_progress + simba_exe_download_weight;
        let _ = tx.send(InstallMessage::Progress(current_progress));

        if !download_github_release(
            &client,
            "https://api.github.com/repos/Torwent/SRL-T/releases/latest",
            "SRL-T.zip",
            &simba_dir,
            &tx,
            &mut current_progress,
            srl_t_download_weight,
        ) {
            return;
        }

        if !download_github_release(
            &client,
            "https://api.github.com/repos/Torwent/WaspLib/releases/latest",
            "WaspLib.zip",
            &simba_dir,
            &tx,
            &mut current_progress,
            wasplib_download_weight,
        ) {
            return;
        }

        if !download_launcher(&client, &simba_dir, &tx, &mut current_progress, launcher_download_weight) {
            return;
        }

        create_shortcut(
            simba_dir.join("Simba64.exe").to_str().unwrap(),
            "Desktop/Simba64",
            "Simba 64 bits",
        );

        create_shortcut(
            simba_dir.to_str().unwrap(),
            "Desktop/SimbaFolder",
            "Simba Folder",
        );

        let _ = tx.send(InstallMessage::Status("Finalizing installation...".to_string()));
        thread::sleep(Duration::from_secs(1));
        current_progress = 1.0;
        let _ = tx.send(InstallMessage::Progress(current_progress));
        let _ = tx.send(InstallMessage::Status("Installation complete!".to_string()));
        let _ = tx.send(InstallMessage::Completed);
    }

    fn show_final_page(&mut self, ui: &mut egui::Ui) {
        ui.with_layout(Layout::top_down(Align::Center), |ui| {
            ui.label("Installation Finished");
            ui.allocate_ui_with_layout(vec2(210.0, 120.0), Layout::top_down(Align::Center), |ui| {
                ui.label("You can start using Simba now!");
                ui.add_space(30.0);
                ui.checkbox(&mut self.run_simba, "Launch Simba");
            });
        });

        ui.with_layout(Layout::bottom_up(Align::RIGHT), |ui| {
            if ui.add_sized([120.0, 35.0], Button::new("Finish")).clicked() {
                if self.run_simba {
                    let simba_path = self.simba_dir.join("Simba64.exe");
                    let _ = Command::new(simba_path).spawn();
                }
                std::process::exit(0);
            }
        });
    }
}

impl eframe::App for SimbaInstaller {
    fn update(&mut self, ctx: &egui::Context, _frame: &mut eframe::Frame) {
        CentralPanel::default().show(ctx, |ui| {
            let size = ui.available_size();
            let width = size.x;
            let height = size.y;

            ui.heading("WaspScripts Simba Installer");
            ui.add_space(height / 3.5);

            match self.page {
                0 => self.show_welcome_page(ui, width, height),
                1 => self.show_existing_install_warning_page(ui),
                2 => self.show_version_selection_page(ui),
                3 => self.show_installation_page(ui),
                4 => self.show_final_page(ui),
                _ => {}
            }
        });
    }
}

const ICON_BYTES: &[u8] = include_bytes!("../assets/wasp.png");

fn load_icon_from_embedded_png(bytes: &[u8]) -> Result<IconData, String> {
    let img = ImageReader::with_format(Cursor::new(bytes), image::ImageFormat::Png)
        .decode()
        .map_err(|e| format!("Failed to decode embedded icon image: {}", e))?;
    let rgba = img.into_rgba8();
    let (width, height) = rgba.dimensions();
    let pixels = rgba.into_raw();
    Ok(IconData { rgba: pixels, width, height })
}

fn main() -> Result<(), eframe::Error> {
    let args: Vec<String> = std::env::args().collect();
    let silent = args.contains(&"--silent".to_string());

    if silent {
        let (tx, rx) = mpsc::channel::<InstallMessage>();
        let simba_dir = PathBuf::from(env::var("LOCALAPPDATA").expect("Could not get LOCALAPPDATA")).join("Simba");

        thread::spawn(move || {
            SimbaInstaller::run_installation_thread(simba_dir, tx);
        });

        for msg in rx {
            match msg {
                InstallMessage::Completed => return Ok(()),
                InstallMessage::Error(_) => std::process::exit(1),
                _ => {}
            }
        }
        return Ok(());
    }

    let icon_data = load_icon_from_embedded_png(ICON_BYTES).expect("Failed to decode embedded app icon!");
    let options = NativeOptions {
        viewport: eframe::egui::ViewportBuilder::default()
            .with_inner_size(eframe::egui::vec2(800.0, 600.0))
            .with_icon(icon_data),
        ..Default::default()
    };

    eframe::run_native(
        "WaspScripts Simba Installer",
        options,
        Box::new(|cc| Ok(Box::new(SimbaInstaller::new(cc, silent)))),
    )
}
