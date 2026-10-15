<div align="center">
  <img src="https://avatars.githubusercontent.com/u/2388970" width="200" height="200">
</div>

# Fortress Forever 2013
## A working port of Fortress Forever on Source SDK 2013.
## Installation instructions:
 1. Install **Fortress Forever** on Steam.
 2. Opt into the beta called **"2013"**. To do so, right-click on the game in your library, then go to Properties.
 3. You will see a Betas option in the list, click on it. You will be shown different betas that can be opted into; no beta means just the current version that runs on [SDK 2006 (or Half-Life 2: Episode One's branch)](https://developer.valvesoftware.com/wiki/Source_2006).
 4. When you opt into the **2013** beta, your game should update/install the required game files for the [Source 2013 version](https://developer.valvesoftware.com/wiki/Source_2013).
 5. Clone this repository and copy the `FortressForever2013` folder to `steamapps/sourcemods`.
 6. If the game does not show in your Steam library already, restart Steam first.
 7. Start the beta up, note that if you use Windows you should see a menu for whether to play the legacy version or the newer one.

And that's it, now you can launch the game through Steam.


## For quickly testing
If you wish to quickly playtest binaries, you can use a [shortcut or batch file](https://developer.valvesoftware.com/wiki/Command_line_options) to launch the game by running the executable with the `-game [PATH_TO_GAME]` launch option. See the batch examples below:

### Windows
`hl2.exe -game "../../../sourcemods/fortressforever" +maxplayers 1 +coop 1 +cl_localnetworkbackdoor 0`

### Linux shell script
NOTE: The Linux executable is found in `Fortress Forever/sdk2013`

`hl2.sh -game "../../../sourcemods/fortressforever" +maxplayers +coop 1 +cl_localnetworkbackdoor 0`

These batch scripts will let you play in singleplayer, as multiplayer mode requires passing Steam DRM to allow connecting at all. You will not be able to use the bots by doing this, however, as they are treated as additional players.
