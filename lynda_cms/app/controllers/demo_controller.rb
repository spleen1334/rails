class DemoController < ApplicationController

  # layout false # generisani layout (application.html.erb)
  layout 'application'

  def index
    # render template: 'demo/index'
    render 'demo/index' # ovo nemora da se kuca jer je default
  end

  def hello
    # ActionPack Class:
    # instance var > omogucava AUTO pristup u template
    @array = [1,2,3,4,5]

    # PARAMS
    # svejedno je da li hash ili symbol
    @id = params['id']
    @page = params[:page]
  end

  def other_hello
    redirect_to :controller => 'demo', action: 'index'
    # redirect_to '/demo/index' # ovo je adresa URL
  end

  # TEMP: samo za testiranje rails TEXT HELPERA
  def text_helpers
  end

  # TEMP: Za sanitize helpere
  def escape_output
  end

  # NUMBER HELPERS:
  #
  # Svi metodi uzimaju vrednost, i opcije
  # :delimiter
  #   Delimits thousands, default ","
  # :separator
  #   Decimal separator, default "."
  # :precision
  #   Decimal places to show, default 2-3
  #
  # number_to_currency(34.5) >> $34.50
  # number_to_currency(34.5, precision: 0, unit: "kr", format: "%n %u") > 35 kr
  #
  # number_to_percentage(34.5) >> 34.500%
  # number_to_percentage(34.5, precision: 1, separator: ',') >> 34.5%
  #
  # number_to_rounded(34.56789) >> 34.568
  # number_to_rounded(34.56789, precision: 6) >> 34.567890
  #
  # number_to_delimited(3456789) >> 3,456,789
  # number_to_delimited(3456789, delimiter: ' ') >> 3 456 789
  #
  # number_to_human(123456789) >> 123 Million
  # number_to_human(123456789, precision: 5) >> 123.46 Million
  #
  # number_to_human_size(1234567) >> 1.18 MB
  # number_to_human_size(1234567, precision: 2) >> 1.2 MB
  #
  # number_to_phone(1234567890) >> 123-456-7890
  # number_to_phone(1234577890,
  #                 area_code: true,
  #                 delimiter: ' ',
  #                 country_code: 1,
  #                 extension: '321') >> +1 (123) 456 7890 x 321
  #
  #
  # DATETIME HELPERS
  #
  # Moze im se pristupiti iz bilo kog dela rails app (a ne samo iz template)
  #
  # Calculations using integers:
  # Sadrzi listu reci koje se mogu koristiti (second,hour, month, year ...)
  # > Time.now + 30.days - 23.minutes
  #
  # ago, from_now methods:
  # > 30.days.from_now - 23.minutes
  #
  # Relative calculation (begging_of_day...)
  # > Time.now.last_year.end_of_month.beginning_of_day
  #
  # Ruby DateTime formating (format string treba da sadrzi format kodove):
  # > datetime.strftime( format_string )
  # > Time.now.strftime(" %B %d, %Y %H:%M")
  #
  # Rails DateTIme formating (ovo je slicno kao i gore ali rails):
  # > datetime.to_s( format_symbol )
  # > Time::DATE_FORMATS
end


# OBJASNJENJE TEMPLATE
#
# hello.html.erb
# Template name: hello
# Process with: erb
# Output format: html
#
# ERB:
# <% execute_code %>
# <%= execute_and_output_code %>
