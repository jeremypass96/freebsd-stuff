#!/bin/sh

# Display a dialog box explaining the purpose of the script
dialog --title "Locale Configuration" --msgbox "This script is for applying the correct locale for your system." 8 30

locale=$(dialog --title "Select Locale" --menu "Please select your desired locale:" 25 50 16 \
    "1" "Afrikaans (South Africa)" \
    "2" "Amharic (Ethiopia)" \
    "3" "Arabic (United Arab Emirates)" \
    "4" "Arabic (Egypt)" \
    "5" "Arabic (Jordan)" \
    "6" "Arabic (Morocco)" \
    "7" "Arabic (Qatar)" \
    "8" "Arabic (Saudi Arabia)" \
    "9" "Belarusian (Belarus)" \
    "10" "Bulgarian (Bulgaria)" \
    "11" "Catalan (Andorra)" \
    "12" "Catalan (Spain)" \
    "13" "Catalan (France)" \
    "14" "Catalan (Italy)" \
    "15" "Czech (Czech Republic)" \
    "16" "Danish (Denmark)" \
    "17" "German (Austria)" \
    "18" "German (Switzerland)" \
    "19" "German (Germany)" \
    "20" "Greek (Greece)" \
    "21" "English (Australia)" \
    "22" "English (Canada)" \
    "23" "English (United Kingdom)" \
    "24" "English (Ireland)" \
    "25" "English (New Zealand)" \
    "26" "English (Philippines)" \
    "27" "English (Singapore)" \
    "28" "English (United States)" \
    "29" "English (South Africa)" \
    "30" "Estonian (Estonia)" \
    "31" "Basque (Spain)" \
    "32" "Finnish (Finland)" \
    "33" "French (Belgium)" \
    "34" "French (Canada)" \
    "35" "French (Switzerland)" \
    "36" "French (France)" \
    "37" "Irish (Ireland)" \
    "38" "Hebrew (Israel)" \
    "39" "Hindi (India)" \
    "40" "Croatian (Croatia)" \
    "41" "Hungarian (Hungary)" \
    "42" "Armenian (Armenia)" \
    "43" "Icelandic (Iceland)" \
    "44" "Italian (Switzerland)" \
    "45" "Italian (Italy)" \
    "46" "Japanese (Japan)" \
    "47" "Kazakh (Kazakhstan)" \
    "48" "Korean (Korea)" \
    "49" "Lithuanian (Lithuania)" \
    "50" "Latvian (Latvia)" \
    "51" "Mongolian (Mongolia)" \
    "52" "Norwegian Bokmal (Norway)" \
    "53" "Dutch (Belgium)" \
    "54" "Dutch (Netherlands)" \
    "55" "Norwegian Nynorsk (Norway)" \
    "56" "Polish (Poland)" \
    "57" "Portuguese (Brazil)" \
    "58" "Portuguese (Portugal)" \
    "59" "Romanian (Romania)" \
    "60" "Russian (Russia)" \
    "61" "Sami (Finland)" \
    "62" "Sami (Norway)" \
    "63" "Slovak (Slovakia)" \
    "64" "Slovenian (Slovenia)" \
    "65" "Serbian (Serbia)" \
    "66" "Swedish (Finland)" \
    "67" "Swedish (Sweden)" \
    "68" "Turkish (Turkey)" \
    "69" "Ukrainian (Ukraine)" \
    "70" "Chinese (Taiwan)" \
    3>&1 1>&2 2>&3)
# Check if the user canceled the selection
if [ $? -ne 0 ]; then
    dialog --title "Locale Configuration" --msgbox "No locale selected. Exiting." 7 30
    exit 1
fi

# Extract the selected locale based on the user's choice
case $locale in
    "1") selected_locale="af_ZA";;
    "2") selected_locale="am_ET";;
    "3") selected_locale="ar_AE";;
    "4") selected_locale="ar_EG";;
    "5") selected_locale="ar_JO";;
    "6") selected_locale="ar_MA";;
    "7") selected_locale="ar_QA";;
    "8") selected_locale="ar_SA";;
    "9") selected_locale="be_BY";;
    "10") selected_locale="bg_BG";;
    "11") selected_locale="ca_AD";;
    "12") selected_locale="ca_ES";;
    "13") selected_locale="ca_FR";;
    "14") selected_locale="ca_IT";;
    "15") selected_locale="cs_CZ";;
    "16") selected_locale="da_DK";;
    "17") selected_locale="de_AT";;
    "18") selected_locale="de_CH";;
    "19") selected_locale="de_DE";;
    "20") selected_locale="el_GR";;
    "21") selected_locale="en_AU";;
    "22") selected_locale="en_CA";;
    "23") selected_locale="en_GB";;
    "24") selected_locale="en_IE";;
    "25") selected_locale="en_NZ";;
    "26") selected_locale="en_PH";;
    "27") selected_locale="en_SG";;
    "28") selected_locale="en_US";;
    "29") selected_locale="en_ZA";;
    "30") selected_locale="et_EE";;
    "31") selected_locale="eu_ES";;
    "32") selected_locale="fi_FI";;
    "33") selected_locale="fr_BE";;
    "34") selected_locale="fr_CA";;
    "35") selected_locale="fr_CH";;
    "36") selected_locale="fr_FR";;
    "37") selected_locale="ga_IE";;
    "38") selected_locale="he_IL";;
    "39") selected_locale="hi_IN";;
    "40") selected_locale="hr_HR";;
    "41") selected_locale="hu_HU";;
    "42") selected_locale="hy_AM";;
    "43") selected_locale="is_IS";;
    "44") selected_locale="it_CH";;
    "45") selected_locale="it_IT";;
    "46") selected_locale="ja_JP";;
    "47") selected_locale="kk_KZ";;
    "48") selected_locale="ko_KR";;
    "49") selected_locale="lt_LT";;
    "50") selected_locale="lv_LV";;
    "51") selected_locale="mn_MN";;
    "52") selected_locale="nb_NO";;
    "53") selected_locale="nl_BE";;
    "54") selected_locale="nl_NL";;
    "55") selected_locale="nn_NO";;
    "56") selected_locale="pl_PL";;
    "57") selected_locale="pt_BR";;
    "58") selected_locale="pt_PT";;
    "59") selected_locale="ro_RO";;
    "60") selected_locale="ru_RU";;
    "61") selected_locale="se_FI";;
    "62") selected_locale="se_NO";;
    "63") selected_locale="sk_SK";;
    "64") selected_locale="sl_SI";;
    "65") selected_locale="sr_RS";;
    "66") selected_locale="sv_FI";;
    "67") selected_locale="sv_SE";;
    "68") selected_locale="tr_TR";;
    "69") selected_locale="uk_UA";;
    "70") selected_locale="zh_TW";;
esac

# Apply the selected language to /etc/login.conf
# Assuming you want to replace ":lang=C.UTF-8:" with the selected language
sed -i '' -E "s/:lang=C.UTF-8:/:lang=$selected_locale.UTF-8:/g" /etc/login.conf

# Reload the login.conf database
cap_mkdb /etc/login.conf

# Display a confirmation dialog
dialog --title "Locale Configuration" --msgbox "Language set to $selected_locale.UTF-8. Please reboot your system for changes to take effect." 10 30