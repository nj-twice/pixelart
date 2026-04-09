{
  description = "Sprite sheet builder";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }:
  let
    pkgs = nixpkgs.legacyPackages.x86_64-linux;
    my-python = pkgs.python3;
    my-python-with-pkgs = my-python.withPackages
      (py-pkgs: with py-pkgs; [
          pillow
        ]
      );
  in {
    # packages.x86_64-linux.default = ...;
    devShells.x86_64-linux.default = pkgs.mkShell {
      # inputsFrom = [
      #   self.packages.x86_64-linux.default
      # ];
      packages = with pkgs; [
        ty
        ruff
        my-python-with-pkgs
      ];
      shellHook = ''
        export PYTHONPATH=${my-python-with-pkgs}/${my-python-with-pkgs.sitePackages}
      '';
    };
  };
}
