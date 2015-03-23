# CONFIG fajl za carrier wave gde podesavamo amazon s3 cloud storage
# ENV['xxx'] je naziv za heroku ENV variable, koju koristimo da bi smo izbegli hardcoding sifara
# heroku config:set S3_ACCESS_KEY=<access key>
if Rails.env.production?
  CarrierWave.configure do |config|
    config.fog_credentials = {
      # Configuration for Amazon S3
      :provider              => 'AWS',
      :aws_access_key_id     => ENV['S3_ACCESS_KEY'],
      :aws_secret_access_key => ENV['S3_SECRET_KEY']
    }
    config.fog_directory     =  ENV['S3_BUCKET']
  end
end
