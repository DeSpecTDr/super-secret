{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  outputs = inputs: let
    lib = inputs.nixpkgs.lib;
    system = "x86_64-linux";
    pkgs = inputs.nixpkgs.legacyPackages.${system};
  in {
    packages.${system}.default = pkgs.ocamlPackages.buildDunePackage {
      pname = "hello";
      version = "0.1.0";
      duneVersion = "3";
      src = ./hello;

      buildInputs = with pkgs.ocamlPackages; [
        lwt
        lambda-term
        base64
      ];

      strictDeps = true;
    };
    devShells.${system}.default = pkgs.mkShell {
      nativeBuildInputs = with pkgs;
        [
          fswatch
        ]
        ++ (with pkgs.ocamlPackages; [
          ocaml
          dune_3
          ocaml-lsp
          ocamlformat
          opam
          utop
          odoc
          findlib
        ]);
      buildInputs = with pkgs.ocamlPackages; [
        lwt
        lambda-term
        base64
      ];
    };
  };
}
