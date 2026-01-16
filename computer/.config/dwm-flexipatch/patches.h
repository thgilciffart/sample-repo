#define BAR_DWMBLOCKS_PATCH 1 /* allows for clickable dwm blocks + statuscmd */
#define BAR_LTSYMBOL_PATCH 1 /* Show layout symbol in bar */
#define BAR_STATUS_PATCH 1  /* Show status in bar */
#define BAR_STATUSCMD_PATCH 1 /* dwmblocks click integration */
/* Status2d allows colors and rectangle drawing in your dwm status bar.
 * This patch is incompatible with the statuscolors patch which takes precedence.
 * This patch is incompatible with the extrabar patch.
 * https://dwm.suckless.org/patches/status2d/
 */
#define BAR_STATUS2D_PATCH 0

/* Supplementary patch should you want to disable alpha for the status2d section */
#define BAR_STATUS2D_NO_ALPHA_PATCH 0

/* Addition to the status2d patch that allows the use of terminal colors (color0 through color15)
 * from xrdb in the status, allowing programs like pywal to change statusbar colors.
 * This adds the C and B codes to use terminal foreground and background colors respectively.
 * E.g. ^B5^ would use color5 as the background color.
 * https://dwm.suckless.org/patches/status2d/
 */
#define BAR_STATUS2D_XRDB_TERMCOLORS_PATCH 0
#define BAR_SYSTRAY_PATCH 1 /* adds a system tray to show in the status bar */
#define BAR_TAGS_PATCH 1 /* show tags symbol in the bar */
#define BAR_WINTITLE_PATCH 1 /* show window title in bar */

/* Title bar modules such as wintitle (default), fancybar and awesomebar
 * do not by default add left and/or right padding as they take up the
 * remaining space. These options allow you explicitly add padding should
 * you need it.
 */
#define BAR_TITLE_RIGHT_PAD_PATCH 0
#define BAR_TITLE_LEFT_PAD_PATCH 0

/* This patch adds a border around the status bar(s) just like the border of client windows.
 * https://codemadness.org/paste/dwm-border-bar.patch
 */
#define BAR_BORDER_PATCH 0

/* Optional addon for the border patch. This makes it so that the bar border is drawn using
 * the background colour of the bar as opposed to the border colour. This allows for the
 * border to have the same transparency as the background thus giving a more uniform look.
 */
#define BAR_BORDER_COLBG_PATCH 0
#define BAR_CENTEREDWINDOWNAME_PATCH 1 /* centers the current client name in the status bar */
/* Allows the bar height to be explicitly set rather than being derived from font.
 * https://dwm.suckless.org/patches/bar_height/
 */
#define BAR_HEIGHT_PATCH 0
#define BAR_HIDEVACANTTAGS_PATCH 1 /* only show tags with clients */

/* Sometimes dwm crashes when it cannot render some glyphs in window titles (usually emoji).
 * This patch is essentially a hack to ignore any errors when drawing text on the status bar.
 * https://groups.google.com/forum/m/#!topic/wmii/7bncCahYIww
 * https://docs.google.com/viewer?a=v&pid=forums&srcid=MDAwODA2MTg0MDQyMjE0OTgzMzMBMDQ3ODQzODkyMTU3NTAyMTMxNTYBX2RUMVNtOUtDQUFKATAuMQEBdjI&authuser=0
 */
#define BAR_IGNORE_XFT_ERRORS_WHEN_DRAWING_TEXT_PATCH 0

/* This patch adds back in the workaround for a BadLength error in the Xft library when color
 * glyphs are used. This is for systems that do not have an updated version of the Xft library
 * (or generally prefer monochrome fonts).
 */
#define BAR_NO_COLOR_EMOJI_PATCH 0

/* This patch adds vertical and horizontal space between the statusbar and the edge of the screen.
 * https://dwm.suckless.org/patches/barpadding/
 */
#define BAR_PADDING_PATCH 0

/* Same as barpadding patch but specifically tailored for the vanitygaps patch in that the outer
 * bar padding is derived from the vanitygaps settings. In addition to this the bar padding is
 * toggled in unison when vanitygaps are toggled. Increasing or decreasing gaps during runtime
 * will not affect the bar padding.
 */
#define BAR_PADDING_VANITYGAPS_PATCH 0

/* Smart bar padding patch that automatically adjusts the padding when there is
 * only one client on the monitor. Works well with vanitygaps and barpadding
 * patches.
 */
#define BAR_PADDING_SMART_PATCH 0

/* This patch adds simple markup for status messages using pango markup.
 * This depends on the pango library v1.44 or greater.
 * You need to uncomment the corresponding lines in config.mk to use the pango libraries
 * when including this patch.
 *
 * Note that the pango patch does not protect against the BadLength error from Xft
 * when color glyphs are used, which means that dwm will crash if color emoji is used.
 *
 * If you need color emoji then you may want to install this patched library from the AUR:
 * https://aur.archlinux.org/packages/libxft-bgra/
 *
 * A long term fix for the libXft library is pending approval of this pull request:
 * https://gitlab.freedesktop.org/xorg/lib/libxft/-/merge_requests/1
 *
 * Also see:
 * https://developer.gnome.org/pygtk/stable/pango-markup-language.html
 * https://lists.suckless.org/hackers/2004/17285.html
 * https://dwm.suckless.org/patches/pango/
 */
#define BAR_PANGO_PATCH 0

/* This patch enables colored text in the status bar. It changes the way colors are defined
 * in config.h allowing multiple color combinations for use in the status script.
 * This patch is incompatible with and takes precedence over the status2d patch.
 *
 * This patch is compatible with the statuscmd patch with the caveat that the first 16 markers
 * are reserved for status colors restricting block signals to 17 through 31.
 *
 * https://dwm.suckless.org/patches/statuscolors/
 */
#define BAR_STATUSCOLORS_PATCH 0

/* This patch adds configuration options for horizontal and vertical padding in the status bar.
 * https://dwm.suckless.org/patches/statuspadding/
 */
#define BAR_STATUSPADDING_PATCH 0

/* This patch adds the ability for dwm to read colors from the linux virtual console.
 *    /sys/module/vt/parameters/default_{red,grn,blu}
 * Essentially this way the colors you use in your regular tty is "mirrored" to dwm.
 * https://dwm.suckless.org/patches/vtcolors/
 */
#define BAR_VTCOLORS_PATCH 0
#define ALWAYSCENTER_PATCH 1 /* always center floating windows */

/* This patch allows windows to be resized with its aspect ratio remaining constant.
 * https://dwm.suckless.org/patches/aspectresize/
 */
#define ASPECTRESIZE_PATCH 0
#define ATTACHASIDE_PATCH 1
#define AUTOSTART_PATCH 1

/* By default, windows that are not visible when requesting a resize/move will not
 * get resized/moved. With this patch, they will.
 * https://dwm.suckless.org/patches/autoresize/
 */
#define AUTORESIZE_PATCH 0
#define BANISH_PATCH 0 /* hides the cursor when the user uses the keyboard. to use uncomment libxfixes and libxi in config.mk */
/* This patch adds a client rule option to allow the border width to be specified on a per
 * client basis.
 *
 * Example rule:
 *    RULE(.class = "Gimp", .bw = 0)
 *
 * https://dwm.suckless.org/patches/borderrule/
 */
#define BORDER_RULE_PATCH 0

/* This patch adds an iscentered rule to automatically center clients on the current monitor.
 * This patch takes precedence over centeredwindowname, alwayscenter and fancybar patches.
 * https://dwm.suckless.org/patches/center/
 */
#define CENTER_PATCH 0

/* A transient window is one that is meant to be short lived and is usually raised by a
 * parent window. Such windows are typically dialog boxes and the like.
 * It should be noted that in dwm transient windows are not subject to normal client rules
 * and they are always floating by default.
 * This patch centers transient windows on the screen like the center patch does. Note that
 * the 6.2 center patch piggy-backed on the updatewindowtype function to ensure that all
 * dialog boxes were centered, transient or not. This function was removed in relation to
 * adding wintype as a client rule filter, hence this no longer works out of the box. This
 * patch restores previous behaviour with the center patch.
 */
#define CENTER_TRANSIENT_WINDOWS_PATCH 0

/* As above, except that the transient window is centered within the position of the parent
 * window, rather than at the center of the screen. This takes precedence over the above patch.
 */
#define CENTER_TRANSIENT_WINDOWS_BY_PARENT_PATCH 0

/* This patch provides the ability to assign different weights to clients in their
 * respective stack in tiled layout.
 * https://dwm.suckless.org/patches/cfacts/
 */
#define CFACTS_PATCH 0

/* This patch allows color attributes to be set through the command line.
 * https://dwm.suckless.org/patches/cmdcustomize/
 */
#define CMDCUSTOMIZE_PATCH 0

/* This patch tweaks the tagging interface so that you can select multiple tags for tag
 * or view by pressing all the right keys as a combo. For example to view tags 1 and 3,
 * hold MOD and then press and hold 1 and 3 together.
 * https://dwm.suckless.org/patches/combo/
 */
#define COMBO_PATCH 0

/* Allow dwm to execute commands from autostart array in your config.h file. When dwm exits
 * then all processes from autostart array will be killed.
 * https://dwm.suckless.org/patches/cool_autostart/
 */
#define COOL_AUTOSTART_PATCH 0

/* The cyclelayouts patch lets you cycle through all your layouts.
 * https://dwm.suckless.org/patches/cyclelayouts/
 */
#define CYCLELAYOUTS_PATCH 0

/* Make dwm respect _MOTIF_WM_HINTS property, and not draw borders around windows requesting
 * for it. Some applications use this property to notify window managers to not draw window
 * decorations.
 * Not respecting this property leads to issues with applications that draw their own borders,
 * like chromium (with "Use system title bar and borders" turned off) or vlc in fullscreen mode.
 * https://dwm.suckless.org/patches/decoration_hints/
 */
#define DECORATION_HINTS_PATCH 0

/* This feature distributes all clients on the current monitor evenly across all tags.
 * It is a variant of the reorganizetags patch.
 * https://dwm.suckless.org/patches/reorganizetags/
 */
#define DISTRIBUTETAGS_PATCH 0

/* By default dwm will terminate on color allocation failure and the behaviour is intended to
 * catch and inform the user of color configuration issues.
 *
 * Some patches like status2d and xresources / xrdb can change colours during runtime, which
 * means that if a color can't be allocated at this time then the window manager will abruptly
 * terminate.
 *
 * This patch will ignore color allocation failures and continue on as normal. The effect of
 * this is that the existing color, that was supposed to be replaced, will remain as-is.
 */
#define DO_NOT_DIE_ON_COLOR_ALLOCATION_FAILURE_PATCH 0

/* Similarly to the dragmfact patch this allows you to click and drag clients to change the
 * cfact to adjust the client's size in the stack. This patch depends on the cfacts patch.
 */
#define DRAGCFACT_PATCH 0

/* This patch lets you resize the split in the tile layout (i.e. modify mfact) by holding
 * the modkey and dragging the mouse.
 * This patch can be a bit wonky with other layouts, but generally works.
 * https://dwm.suckless.org/patches/dragmfact/
 */
#define DRAGMFACT_PATCH 0
#define DWMC_PATCH 1 /* allows for sxhkd uncomment the following line in Makefile: #cp -f patch/dwmc ${DESTDIR}${PREFIX}/bin */
#define FOCUSDIR_PATCH 1 /* switch focus with up down left right */
#define FOCUSONCLICK_PATCH 1 /* focus only when click */
#define ISPERMANENT_PATCH 1 /* prevents sticky clients from being accidentally terminated */
#define LOSEFULLSCREEN_PATCH 1 /* makes sure spawning new windows under fullscreen don't get hidden */
/* This patch allows you to move and resize dwm's clients using keyboard bindings.
 * https://dwm.suckless.org/patches/moveresize/
 */
#define MOVERESIZE_PATCH 1
#define NOBORDER_PATCH 1 /* remove the client border when its only 1 client in the tag */
#define PERTAG_PATCH 1 /* layouts/mfacts/nmaster is per tag rather than monitor */
#define PLACEDIR_PATCH 1 /* move clients in any directio N/S E/W */
#define PLACEMOUSE_PATCH 1 /* reorder clients with the mouse  */
#define RESIZEPOINT_PATCH 1 /* cursor stays in place whne warp */
#define SAVEFLOATS_PATCH 1 /* saves the size and pos of every floating window before it is forced into tiled */
#define SPAWNCMD_PATCH 1 /* spawn programs from currently focused clients working directory */
#define STEAM_PATCH 0 /* fixes steam games jumping around */
#define STICKY_PATCH 1 /* shortcut to make a client appear on all tags/workspaces */
#define SWALLOW_PATCH 1 /* allows for window swallowing eg. launch a browser from terminal and it will swallow that terminal until you close the browser. depends on libxcb, Xlib-libxcb and xcb-res */
#define SWAPFOCUS_PATCH 1 /* swaps focus between the last 2 recent with a single keybind */
#define TOGGLEFULLSCREEN_PATCH 1 /* shortcut to fullscreen an application */
#define VANITYGAPS_PATCH 1 /* gaps for the windows */
#define VIEWONTAG_PATCH 1 /* follows the window a new workspace */
#define WARP_PATCH 1 /* goes to the center of the window */
#define XRESOURCES_PATCH 1
#define FLEXTILE_DELUXE_LAYOUT 1
