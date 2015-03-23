require 'test_helper'

class ProductTest < ActiveSupport::TestCase

  # Ucitavanje FIXTURES
  # fixtures :products # nije obavezno jer se radi po default

  test "product attributes must not be empty" do
    product = Product.new

    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:image_url].any?
    assert product.errors[:price].any?
  end

  test "products price must be positive" do
    product = Product.new(
      title:       "My Book Title" ,
      description: "nesto random ide ovde ... " ,
      image_url:   "zzz.jpg"
    )

    product.price = -1
    assert product.invalid?
    assert_equal ["must be greater than or equal to 0.01"], product.errors[:price]

    product.price = 0
    assert product.invalid?
    assert_equal ["must be greater than or equal to 0.01"], product.errors[:price]

    product.price = 1
    assert product.valid?
  end

  # IMAGE URL TEST
  def new_product(image_url)
    Product.new( title:       "My Book Title" ,
                  description: "nesto random ide ovde ... " ,
                  price: 1,
                  image_url:   image_url )
  end

  test "image url" do
    ok = %w{ fred.gif fred.jpg fred.png FRED.Gif FRED.JPG http://a.b.c/x/y/z/fred.gif }
    bad = %w{ fred.doc fred.gif/more fred.gif.more }

    ok.each do |name|
      assert new_product(name).valid?, "#{name} should be valid"
    end

    bad.each do |name|
      assert new_product(name).invalid?, "#{name} shouldn't be valid"
    end
  end

  test "product is not valid without unique title" do
    product = Product.new( title: products(:ruby).title,
                            description: "Random crap text itd..",
                            price: 1,
                            image_url: "fred.gif")
    assert product.invalid?
    assert_equal ["has already been taken"], product.errors[:title]
  end


end


# KOMENTARI:
# The simplest assertion is the method assert() , which expects its argument to
# be true.
# assert 1+1 = 2
# assert 1+1 =2, "1+1 uvek daju broj 2"
#
#
#
# FIXTURES:
#
# YAML Format.
#
# Ucitavaju se u fajl sa:
# Automatski su ucitani tako da nemora explicitno loadovanje.
# Config se nalazi u test_helper.rb
# fixtures :products # :products = products.yml
#
# Oni su ucitani u DB pre izvrsavanja testova.
#
# Rake za kreiranje test db:
# rake db:test:prepare
#
# Koriscenje u testu:
# For each fixture it loads into
# a test, Rails defines a method with the same name as the fixture.
#
# npr: products(:ruby).title # products = table name, :ruby = naziv row, title
# = attr
#
# Definicija:
# In the world of Rails, a test fixture is simply a specification of the initial con-
# tents of a model (or models) under test.
#
# ZASTO KORISTITI FIXTURE OVDE:
# products(:ruby).title ?
# Odgovor je zbog toga sto se products(:ruby).title preuzima iz DB, on NIJE
# samo var, on je snimljen u test DB pre pokretanja testa.

# Finally, our model contains a validation that checks that all the product titles
# in the database are unique. To test this one, we’re going to need to store
# product data in the database.
#
