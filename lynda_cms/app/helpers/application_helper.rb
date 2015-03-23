module ApplicationHelper

  # Helper za form error iz validacije
  def error_messages_for(object)
    render partial: 'application/error_messages', locals: { object: object }
  end

  def status_tag(boolean, options={})
    options[:true_text] ||= ''
    options[:false_text] ||= ''

    if boolean
      content_tag(:span, options[:true_text], class: 'status true')
    else
      content_tag(:span, options[:false_text], :class => 'status false')
    end
  end
end

# HELPER METHODE ZA CELU APP IDU OVDE
#
# SANITAZE HELPERS
# ----------------
#
# Zastitne metode koje escape-uju sav user content.
# Po defaultu rails sve tretira kao opasnost (whitelisting).
#
# html_escape() , h() >> po defaultu automatski primenjene na sve podatke iz
# .erb
#
# raw() >> prikazuje string bez safety escapeovanja, samo JEDNOM
# html_safe >> obelezava neki string kao bezbednim i svugde se ignorisu escape
# provere
# html_safe? >> proverava da li je neki string safe
#
# strip_links(html) >> remove all <a> iz html
#
# strip_tags(html) >> uklanja sve html tagove i ostavlja samo txt
#
# sanitize(html, options) >> slicno sto i strip_tags ali u :options moze se
# navesti array za whitelist
