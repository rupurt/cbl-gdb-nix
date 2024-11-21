{
  pkgs,
  specialArgs ? {},
}: let
  defaultArgs = {
    pname = "cbl-gdb";
    owner = "COBOLworx";
    repo = "cbl-gdb";
    rev = "master";
    version = "5.3.1";
    sha256 = "sha256-IViYSxbK85qQiOeQFt93xtpiMsso7Qh9lQWiMjutakk=";
  };
  args = defaultArgs // specialArgs;
  repo = pkgs.fetchFromGitLab {
    domain = "gitlab.cobolworx.com";
    owner = args.owner;
    repo = args.repo;
    rev = args.rev;
    sha256 = args.sha256;
  };
in
  pkgs.gccStdenv.mkDerivation {
    pname = args.pname;
    version = args.version;
    src = repo;

    nativeBuildInputs = with pkgs; [
      pkg-config
    ];

    buildInputs = with pkgs; [
      gnucobol
      python312
    ];

    patches = [
      ./0001-use-PATH-echo.patch
    ];

    buildPhase = ''
      runHook preBuild

      make prefix=$out COBCD=$out/bin/cobcd PYTHON=${pkgs.python312}/bin/python

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      make prefix=$out COBCD=$out/bin/cobcd PYTHON=${pkgs.python312}/bin/python install

      runHook postInstall
    '';

    enableParallelBuilding = true;

    meta = with pkgs.lib; {
      description = "COBOLworx cbl-gdb debugging extensions to GnuCOBOL";
      homepage = "https://gitlab.cobolworx.com/COBOLworx/cbl-gdb";
      license = with licenses; [openldap];
      maintainers = with maintainers; [rupurt];
      platforms = platforms.all;
    };
  }
