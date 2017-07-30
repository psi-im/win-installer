#include <QtCore/QCoreApplication>
#include <QDir>
#include <iostream>

/**
 * You have to manually update language lists below.
 * For Psi you can generate it from included dictionary file names
 * For nsis see command below
 *
 * As result this code generates contents for spell_lang.map
 *
 */

using namespace std;

int main(int argc, char *argv[])
{
    QCoreApplication app(argc, argv);

    QLocale aragonese(QLocale::Aragonese, QLocale::Spain);
    QLocale kurdish(QLocale::Kurdish, QLocale::Turkey);

    QHash<QString,QString> replaceLangs;
    replaceLangs.insert("kmr_Latn", kurdish.name());
    replaceLangs.insert("an_ES", aragonese.name());

    // supported by psi
    QString s("af_ZA an_ES ar be_BY bg_BG bn_BD br_FR bs_BA cs_CZ da_DK de_AT_frami de_CH_frami de_DE_frami el_GR "
              "en_AU en_CA en_GB en_US en_ZA es_ANY et_EE fr gl_ES gu_IN he_IL hi_IN hr_HR hu_HU is it_IT "
  "kmr_Latn lo_LA lt lv_LV nb_NO ne_NP nl_NL nn_NO oc_FR pl_PL pt_BR pt_PT ro_RO ru_RU si_LK sk_SK sl_SI sr "
  "sr-Latn sv_FI sv_SE sw_TZ te_IN th_TH uk_UA vi_VN");

    // supported by nsis
    // echo $(cat ./Contrib/MakeLangId/MakeLangId.cpp | grep -P '^\s+IL' | cut -d ',' -f 3 | sort -u)
    auto nsisLangs = QString("AFRIKAANS ALBANIAN ARABIC ARMENIAN ASSAMESE AZERI BASQUE BELARUSIAN BENGALI "
                                    "BULGARIAN CATALAN CHEROKEE CHINESE CORSICAN CROATIAN CZECH DANISH DIVEHI DUTCH "
                                    "ENGLISH ESTONIAN FAEROESE FARSI FILIPINO FINNISH FRENCH GALICIAN GEORGIAN GERMAN "
                                    "GREEK GUJARATI HAWAIIAN HEBREW HINDI HUNGARIAN ICELANDIC INDONESIAN INVARIANT "
                                    "ITALIAN JAPANESE KASHMIRI KAZAK KHMER KOREAN KYRGYZ LAO LATVIAN LITHUANIAN "
                                    "MACEDONIAN MALAY MALAYALAM MALTESE MARATHI MONGOLIAN NEPALI NORWEGIAN ORIYA "
                                    "POLISH PORTUGUESE ROMANIAN RUSSIAN SANSKRIT SCOTTISH_GAELIC SERBIAN SLOVAK "
                                    "SLOVENIAN SPANISH SWAHILI SWEDISH SYRIAC THAI TIBETAN TURKISH UKRAINIAN UZBEK "
                                    "VIETNAMESE WELSH").split(' ').toSet();

    QStringList localesStr = s.split(' ');
    QList<QPair<QString,QLocale>> locales;
    QHash<QLocale::Language, QSet<QLocale::Script>> scripts;
    QHash<QLocale::Language, QSet<QLocale::Country>> countries;
    for (auto &l : localesStr) {
        QLocale locale(replaceLangs.contains(l)? replaceLangs[l] : l);
        locales.append(QPair<QString,QLocale>(l, locale));
        scripts[locale.language()].insert(locale.script());
        countries[locale.language()].insert(locale.country());
    }

    for (auto &l : locales) {

        QByteArray dictCode = l.first.toLocal8Bit();
        QLocale locale = l.second;
        QString language = QLocale::languageToString(locale.language()).toUpper();

        std::cout << dictCode.data() << "\tSpellLang_" << dictCode.data() << "\t";
        if (nsisLangs.contains(language)) {
            std::cout << "LANG_" << language.toLocal8Bit().data() << "\t";
        } else {
            std::cout << "\t\t";
        }
        std::cout << QLocale::languageToString(locale.language()).toLocal8Bit().data();
        if (scripts[locale.language()].count() > 1 || countries[locale.language()].count() > 1) {
            QStringList features;
            if (scripts[locale.language()].count() > 1) {
                features.append(QLocale::scriptToString(locale.script()));
            }
            if (countries[locale.language()].count() > 1) {
                features.append(QLocale::countryToString(locale.country()));
            }
            std::cout << " (" << features.join(',').toLocal8Bit().data() << ")";
        }

        std::cout << "\n";
    }

	return 0;
}
