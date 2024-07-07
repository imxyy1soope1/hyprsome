{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    crane.url = "github:ipetkov/crane";
    crane.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, crane, ... }:
    let
      forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;
      hyprsome = craneLib: craneLib.buildPackage {
        src = craneLib.cleanCargoSource (craneLib.path ./.);
      };
    in
    {
      packages = forAllSystems (system:
        let
          craneLib = crane.mkLib nixpkgs.legacyPackages.${system};
        in
          {
            default = hyprsome craneLib;
            hyprsome = hyprsome craneLib;
          }
      );
      overlays.default = (final: prev: 
      let
        craneLib = crane.mkLib final;
      in
      {
        hyprsome = hyprsome craneLib;
      });
    };
}
