{
  description = "A basic Gleam dev shell";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in
  rec {
    dependencies = with pkgs; [
      gleam
      inotify-tools
      beam27Packages.erlang
      beam27Packages.rebar3
    ];

    devShells.${system}.default = pkgs.mkShell {
      buildInputs = dependencies;
      shellHook = "echo 'Gleam shell init complete.'";
    };
  };
}
