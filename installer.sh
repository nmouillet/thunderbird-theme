#!/usr/bin/env bash
# Installe le thème dans tous les profils Thunderbird de l'utilisateur (aucun droit admin, rejouable) :
# - copie chrome/ dans le dossier chrome/ de chaque profil (~/.config/thunderbird ou ~/.thunderbird) ;
# - active userChrome.css dans user.js (toolkit.legacyUserProfileCustomizations.stylesheets).
# Thunderbird fermé.
#
# Usage : ./installer.sh      ./installer.sh --verifier (contrôle seulement)
set -uo pipefail

# En fin de script (réussite ou erreur), attendre une touche avant de rendre la main.
# Seulement au clavier : lancé par Claude ou dans un tube, pas de pause.
pause_finale() { [ -t 0 ] && [ -t 1 ] || return 0; echo; read -rsn1 -p "Appuie sur une touche pour terminer…" _ || true; echo; }
trap pause_finale EXIT

ok() { printf '\033[1;32m✅ %s\033[0m\n' "$*"; }
ko() { printf '\033[1;31m❌ %s\033[0m\n' "$*"; }

verifier=0; [ "${1:-}" = "--verifier" ] && verifier=1
erreurs=0
DOSSIER=$(cd "$(dirname "$0")" && pwd)
pref='user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);'

profils=(); for p in ~/.config/thunderbird/*/prefs.js ~/.thunderbird/*/prefs.js; do [ -e "$p" ] && profils+=("$(dirname "$p")"); done
if [ ${#profils[@]} = 0 ]; then
    ko "Aucun profil Thunderbird : lancer Thunderbird une fois, le fermer, puis relancer ce script."
    exit 1
fi
if [ "$verifier" = 0 ] && pgrep -x thunderbird >/dev/null; then
    ko "Thunderbird est ouvert : le fermer, puis relancer ce script."
    exit 1
fi
for profil in "${profils[@]}"; do
    nom=$(basename "$profil")
    # Fichiers du thème absents ou différents dans le profil (les fichiers en plus dans le profil sont ignorés)
    ecarts=$(LC_ALL=C diff -rq "$DOSSIER/chrome" "$profil/chrome" 2>&1 | grep -v "^Only in $profil/chrome")
    if [ -z "$ecarts" ] && grep -qxF "$pref" "$profil/user.js" 2>/dev/null; then
        ok "Thème en place ($nom)."
        continue
    fi
    if [ "$verifier" = 1 ]; then
        ko "Thème absent ou pas à jour ($nom)."; erreurs=1; continue
    fi
    mkdir -p "$profil/chrome"
    cp -rT "$DOSSIER/chrome" "$profil/chrome"
    grep -qxF "$pref" "$profil/user.js" 2>/dev/null || echo "$pref" >> "$profil/user.js"
    ok "Thème installé ($nom)."
done

[ "$erreurs" = 0 ] && ok "Thunderbird prêt : le relancer pour appliquer." || exit 1
