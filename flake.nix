{
  description = "MS Teams Video & Transcript Downloader - browser extension";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        manifest = builtins.fromJSON (builtins.readFile ./src/manifest.json);
        version = manifest.version;
      in {
        packages = {
          default = pkgs.stdenvNoCC.mkDerivation {
            pname = "ms-teams-downloader";
            inherit version;
            src = ./src;
            phases = [ "installPhase" ];
            installPhase = ''
              mkdir -p $out
              cp -r $src/* $out/
              rm -f $out/key.pem
            '';
          };

          chrome-zip = pkgs.stdenvNoCC.mkDerivation {
            pname = "ms-teams-downloader-chrome";
            inherit version;
            src = ./src;
            nativeBuildInputs = with pkgs; [ zip ];
            buildPhase = ''
              runHook preBuild
              zip -r ms-teams-downloader-v${version}.zip . \
                -x "key.pem" -x ".DS_Store" -x "Thumbs.db"
              runHook postBuild
            '';
            installPhase = ''
              runHook preInstall
              mkdir -p $out
              cp *.zip $out/
              runHook postInstall
            '';
          };

          firefox-zip = pkgs.stdenvNoCC.mkDerivation {
            pname = "ms-teams-downloader-firefox";
            inherit version;
            src = ./src;
            nativeBuildInputs = with pkgs; [ zip ];
            buildPhase = ''
              runHook preBuild

              # Firefox requires browser_specific_settings.gecko.id
              grep -q '"browser_specific_settings"' manifest.json || \
                { echo "ERROR: Firefox package requires browser_specific_settings in manifest.json"; exit 1; }

              zip -r ms-teams-downloader-firefox-v${version}.zip . \
                -x "key.pem" -x ".DS_Store" -x "Thumbs.db"
              runHook postBuild
            '';
            installPhase = ''
              runHook preInstall
              mkdir -p $out
              cp *.zip $out/
              runHook postInstall
            '';
          };
        };

        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            powershell
            web-ext
          ];
        };
      }
    );
}
