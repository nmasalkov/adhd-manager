module ApplicationHelper
  LOCALE_FULL_NAME = { en: 'English', ru: 'Русский' }

  def locale_full_name(locale)
    LOCALE_FULL_NAME[locale]
  end
end
