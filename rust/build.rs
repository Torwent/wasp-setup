fn main() {
    if cfg!(target_os = "windows") {
        let mut res = winres::WindowsResource::new();
        res.set_icon("assets/wasp.ico");
        res.compile().unwrap();
    }
}
