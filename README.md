# thunderbird-theme

Thème Thunderbird au style Windows 11 / Outlook, adapté à **Linux et KDE Plasma**.

Il reprend **[FluentBird](https://github.com/Deathbyteacup/fluentbird)** de
[Danny King](https://www.dannyking.co.uk) (licence MIT), un thème `userChrome.css` qui applique
le Fluent Design de Windows 11 à Thunderbird, et y ajoute des retouches pour Linux.
Tout le mérite du thème revient à FluentBird ; ce dépôt n'ajoute que `chrome/custom.css` et `installer.sh`.

## Retouches par rapport à FluentBird

| Retouche | Pourquoi |
|---|---|
| Fenêtre entièrement opaque | La transparence de FluentBird sert à l'effet Mica de Windows 11 ; sous Linux, elle laisse voir les fenêtres de derrière. |
| Menu ☰ réaffiché | FluentBird le masque, alors qu'il donne accès aux paramètres. |
| Onglet actif teinté de bleu, avec un trait en bas | Sinon il se distingue mal des autres en mode sombre. |
| Messages non lus sur fond bleuté, avec un liseré à gauche | Comme dans Outlook. |
| Boutons de la fenêtre écartés du bord droit | Trop collés au bord sous Plasma. |

Le thème suit le mode clair ou sombre du système, comme FluentBird.

## Installation

Prérequis : Thunderbird (testé avec la version 156), lancé au moins une fois pour créer le profil.
Dans *Paramètres → Général*, le thème doit rester sur « Système » (aucun autre thème installé).

```bash
git clone https://github.com/nmouillet/thunderbird-theme.git
cd thunderbird-theme
./installer.sh              # Thunderbird fermé
./installer.sh --verifier   # contrôle seulement
```

`installer.sh` ne demande aucun droit admin. Pour chaque profil (`~/.config/thunderbird/*` ou `~/.thunderbird/*`),
il copie `chrome/` dans le dossier `chrome/` du profil et ajoute à `user.js` la préférence
`toolkit.legacyUserProfileCustomizations.stylesheets = true`, qui active `userChrome.css`.
Il se relance sans risque, par exemple après une mise à jour du dépôt.

**Désinstaller** : Thunderbird fermé, supprimer le dossier `chrome/` du profil
(*Aide → Informations de dépannage → Dossier de profil*), puis la ligne ajoutée dans `user.js`.

## Organisation

- `chrome/userChrome.css`, `chrome/Icons/`, `chrome/Titlebar_Icons/` : FluentBird 1.1.4, **non modifiés**.
- `chrome/custom.css` : les retouches, importées par `userChrome.css`. Elles utilisent le préfixe
  `:root:root`, car ce fichier est chargé avant les règles de FluentBird et doit l'emporter sur elles.

Pour passer à une nouvelle version de FluentBird : remplacer `userChrome.css`, `Icons/` et `Titlebar_Icons/`
par ceux de la nouvelle version, sans toucher à `custom.css`, puis relancer `installer.sh`.

## Limites (héritées de FluentBird)

La fenêtre de rédaction, les fenêtres secondaires et les paramètres ne sont pas thémés :
Thunderbird les affiche hors de portée de `userChrome.css`.

## Crédits et licence

- **FluentBird** © 2025 Danny King — <https://github.com/Deathbyteacup/fluentbird> — licence MIT.
- Icônes Fluent Design © Microsoft Corporation, licence MIT (incluses dans FluentBird).
- Retouches © 2026 Nicolas Mouillet — licence MIT.

Voir [LICENSE](LICENSE).
