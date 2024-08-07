{ pkgs }:

let
  inherit (pkgs)
    fetchFromGitHub
    callPackage
    emacsPackages
    emacsPackagesFor
    emacs29
  ;

in
(emacsPackagesFor emacs29).emacsWithPackages (epkgs: with epkgs; [
  (exwm.overrideDerivation (o: {
    # https://github.com/ch11ng/exwm/issues/759
    postInstall = ''
        cd $out/share/emacs/site-lisp/elpa/exwm-${o.version}
        sed -i '/(cl-pushnew xcb:Atom:_NET_WM_STATE_HIDDEN exwm--ewmh-state)/d' exwm-layout.el
        rm exwm-layout.elc
      '';
  }))
  xelb

  buffer-move
  cape
  cl-lib
  cmake-mode
  color-theme-sanityinc-tomorrow
  counsel # for starting linux apps
  consult
  corfu
  dockerfile-mode
  dumb-jump
  eglot-fsharp
  envrc
  exec-path-from-shell
  flycheck
  forge
  format-all
  fsharp-mode
  hcl-mode
  jinja2-mode
  kubernetes
  magit
  markdown-preview-mode
  modus-themes
  multiple-cursors
  orderless
  protobuf-mode
  projectile
  pdf-tools
  python-mode
  rainbow-delimiters
  rainbow-mode
  restclient
  rotate
  rust-mode
  rustic
  cargo-mode
  sudo-edit
  tide
  telephone-line
  terraform-mode
  transient
  treesit-grammars.with-all-grammars
  undo-tree
  vertico
  vterm
  vterm-toggle
  web-mode
  which-key
  winum
  yaml-mode
  yasnippet
  cargo-mode

  fsharp-mode
  go-mode

  eglot-fsharp
])
