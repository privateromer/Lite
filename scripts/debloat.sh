#!/bin/bash


# GENERAL / SYSTEM / BLOAT
DEBLOAT_APPS=(
"HMT"
)


# KOREAN / CARRIER APPS
CARRIER_APPS=(
"KTAuth"
)


# SAMSUNG FEATURES / APPS
SAMSUNG_APPS=(
"OfflineLanguageModel_stub"
)


# SAMSUNG DEX APPS
SAMSUNG_DEX_APPS=(
"SystemUIDesktop"
)


# SAMSUNG BIXBY APPS
SAMSUNG_BIXBY_APPS=(
"BixbyWakeup"
)


# SAMSUNG AI / SMART
SAMSUNG_AI=(
"SmartEye"
)


# GOOGLE APPS
GOOGLE_APPS=(
"SpeechServicesByGoogle"
)


# FACEBOOK
FACEBOOK_APPS=(
"FBAppManager_NS"
)


# DRIVERS
HARDWARE_DRIVERS=(
"DevGPUDriver-EX2200"
)


# MISC / SERVICES
MISC_SERVICES=(
"AuthFramework"
)


# Knox
KNOX_APPS=(
"Rampart"
)


REMOVE_ESIM_FILES() {
    if [ "$#" -ne 1 ]; then
        echo -e "Usage: ${FUNCNAME[0]} <EXTRACTED_FIRM_DIR>"
        return 1
    fi

	local EXTRACTED_FIRM_DIR="$1"
    echo -e "- Removing ESIM files."
	rm -rf "$EXTRACTED_FIRM_DIR/system/system/etc/autoinstalls/autoinstalls-com.google.android.euicc"
	rm -rf "$EXTRACTED_FIRM_DIR/system/system/etc/default-permissions/default-permissions-com.google.android.euicc.xml"
	rm -rf "$EXTRACTED_FIRM_DIR/system/system/etc/permissions/privapp-permissions-com.samsung.euicc.xml"
	rm -rf "$EXTRACTED_FIRM_DIR/system/system/etc/permissions/privapp-permissions-com.samsung.android.app.esimkeystring.xml"
	rm -rf "$EXTRACTED_FIRM_DIR/system/system/etc/permissions/privapp-permissions-com.samsung.android.app.telephonyui.esimclient.xml"
	rm -rf "$EXTRACTED_FIRM_DIR/system/system/etc/privapp-permissions-com.samsung.android.app.telephonyui.esimclient.xml"
    rm -rf "$EXTRACTED_FIRM_DIR/system/system/etc/sysconfig/preinstalled-packages-com.samsung.euicc.xml"
    rm -rf "$EXTRACTED_FIRM_DIR/system/system/etc/sysconfig/preinstalled-packages-com.samsung.android.app.esimkeystring.xml"
	rm -rf "$EXTRACTED_FIRM_DIR/system/system/priv-app/EsimClient"
    rm -rf "$EXTRACTED_FIRM_DIR/system/system/priv-app/EsimKeyString"
    rm -rf "$EXTRACTED_FIRM_DIR/system/system/priv-app/EuiccService"
	rm -rf "$EXTRACTED_FIRM_DIR/system/system/priv-app/EuiccGoogle"
}


REMOVE_FABRIC_CRYPTO() {
    if [ "$#" -ne 1 ]; then
        echo -e "Usage: ${FUNCNAME[0]} <EXTRACTED_FIRM_DIR>"
        return 1
    fi

	local EXTRACTED_FIRM_DIR="$1"
    echo -e "- Removing fabric crypto."
    rm -rf "$EXTRACTED_FIRM_DIR/system/system/bin/fabric_crypto"
    rm -rf "$EXTRACTED_FIRM_DIR/system/system/etc/init/fabric_crypto.rc"
    rm -rf "$EXTRACTED_FIRM_DIR/system/system/etc/permissions/FabricCryptoLib.xml"
    rm -rf "$EXTRACTED_FIRM_DIR/system/system/etc/vintf/manifest/fabric_crypto_manifest.xml"
    rm -rf "$EXTRACTED_FIRM_DIR/system/system/framework/FabricCryptoLib.jar"
    rm -rf "$EXTRACTED_FIRM_DIR/system/system/framework/oat/arm/FabricCryptoLib.odex"
	rm -rf "$EXTRACTED_FIRM_DIR/system/system/framework/oat/arm/FabricCryptoLib.vdex"
	rm -rf "$EXTRACTED_FIRM_DIR/system/system/framework/oat/arm64/FabricCryptoLib.odex"
	rm -rf "$EXTRACTED_FIRM_DIR/system/system/framework/oat/arm64/FabricCryptoLib.vdex"
    rm -rf "$EXTRACTED_FIRM_DIR/system/system/lib64/com.samsung.security.fabric.cryptod-V1-cpp.so"
    rm -rf "$EXTRACTED_FIRM_DIR/system/system/lib64/vendor.samsung.hardware.security.fkeymaster-V1-ndk.so"
    rm -rf "$EXTRACTED_FIRM_DIR/system/system/priv-app/KmxService"
}


KICK() {
    if [ "$#" -lt 2 ]; then
        echo -e "Usage: ${FUNCNAME[0]} <EXTRACTED_FIRM_DIR> <APPS...>"
        return 1
    fi
    
    local EXTRACTED_FIRM_DIR="$1"
    shift
    local APPS_LIST=("$@")

    local APP_DIRS=(
        "$EXTRACTED_FIRM_DIR/system/system/app"
        "$EXTRACTED_FIRM_DIR/system/system/priv-app"
        "$EXTRACTED_FIRM_DIR/product/app"
        "$EXTRACTED_FIRM_DIR/product/priv-app"
    )

    for app in "${APPS_LIST[@]}"; do
        for dir in "${APP_DIRS[@]}"; do
            target="$dir/$app"

            if [[ -d "$target" ]]; then
                rm -rf "$target" || echo -e "[WARN] Failed to delete $target"
            fi
        done
    done
}


DEBLOAT_SAMSUNG_BIXBY_APPS() {
    echo -e ""
    if [ "$#" -ne 1 ]; then
        echo -e "Usage: ${FUNCNAME[0]} <EXTRACTED_FIRM_DIR>"
        return 1
    fi

	local EXTRACTED_FIRM_DIR="$1"

	if [ ! -d "$EXTRACTED_FIRM_DIR/system" ]; then
	    echo -e "No extracted firmware found."
        return 1
    fi

    echo -e "Debloating samssung bixby apps."

	# Debloat samsung bixby apps
	echo "- Debloating apps."
    KICK "$EXTRACTED_FIRM_DIR" "${SAMSUNG_BIXBY_APPS[@]}"
}


DEBLOAT_SAMSUNG_DEX_APPS() {
    echo -e ""
    if [ "$#" -ne 1 ]; then
        echo -e "Usage: ${FUNCNAME[0]} <EXTRACTED_FIRM_DIR>"
        return 1
    fi

	local EXTRACTED_FIRM_DIR="$1"

	if [ ! -d "$EXTRACTED_FIRM_DIR/system" ]; then
	    echo -e "No extracted firmware found."
        return 1
    fi

    echo -e "Debloating samssung dex apps."

	# Debloat samsung dex apps
	echo "- Debloating apps."
    KICK "$EXTRACTED_FIRM_DIR" "${SAMSUNG_DEX_APPS[@]}"
}


DEBLOAT() {
    echo -e ""
    if [ "$#" -ne 1 ]; then
        echo -e "Usage: ${FUNCNAME[0]} <EXTRACTED_FIRM_DIR>"
        return 1
    fi

	local EXTRACTED_FIRM_DIR="$1"

	if [ ! -d "$EXTRACTED_FIRM_DIR/system" ]; then
	    echo -e "No extracted firmware found."
        return 1
    fi

    echo -e "Debloating apps and files."

	# Debloat apps
	echo "- Debloating apps."
    KICK "$EXTRACTED_FIRM_DIR" "${DEBLOAT_APPS[@]}"
    KICK "$EXTRACTED_FIRM_DIR" "${CARRIER_APPS[@]}"
    KICK "$EXTRACTED_FIRM_DIR" "${SAMSUNG_APPS[@]}"
    KICK "$EXTRACTED_FIRM_DIR" "${SAMSUNG_AI[@]}"
    KICK "$EXTRACTED_FIRM_DIR" "${GOOGLE_APPS[@]}"
    KICK "$EXTRACTED_FIRM_DIR" "${FACEBOOK_APPS[@]}"
    KICK "$EXTRACTED_FIRM_DIR" "${HARDWARE_DRIVERS[@]}"
    KICK "$EXTRACTED_FIRM_DIR" "${MISC_SERVICES[@]}"
    KICK "$EXTRACTED_FIRM_DIR" "${KNOX_APPS[@]}"
	REMOVE_FABRIC_CRYPTO "$EXTRACTED_FIRM_DIR"

	echo -e "- Deleting unnecessary files and folders."
    rm -rf "$EXTRACTED_FIRM_DIR/system/system/etc/init/boot-image.bprof"
    rm -rf "$EXTRACTED_FIRM_DIR/system/system/etc/public.libraries-edensdk.samsung.txt"
	rm -rf "$EXTRACTED_FIRM_DIR/system/system/etc/proca.db"
	rm -rf "$EXTRACTED_FIRM_DIR/system/system/bin/ssud"
	rm -rf "$EXTRACTED_FIRM_DIR/system/system/etc/init/ssu.rc"
	rm -rf "$EXTRACTED_FIRM_DIR/system/system/etc/permissions/privapp-permissions-com.samsung.ssu.xml"
	rm -rf "$EXTRACTED_FIRM_DIR/system/system/etc/sysconfig/samsungsimunlock.xml"
	rm -rf "$EXTRACTED_FIRM_DIR/system/system/lib64/android.security.securekeygeneration-ndk.so"
	rm -rf "$EXTRACTED_FIRM_DIR/system/system/lib64/libssu_keystore2.so"
	rm -rf "$EXTRACTED_FIRM_DIR/system/system/priv-app/SsuService"
	rm -rf "$EXTRACTED_FIRM_DIR/system/system/etc/permissions/privapp-permissions-com.samsung.android.app.updatecenter.xml"
    rm -rf "$EXTRACTED_FIRM_DIR/system/system/etc/init/boot-image.prof"
}
