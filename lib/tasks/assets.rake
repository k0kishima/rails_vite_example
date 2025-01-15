namespace :assets do
  desc "Sync Vite-built assets to S3"
  task sync_vite: :environment do
    s3 = Aws::S3::Resource.new(region: ENV['AWS_REGION'])
    bucket_name = ENV['S3_BUCKET_NAME']
    bucket = s3.bucket(bucket_name)

    unless bucket.exists?
      abort "Error: Bucket #{bucket_name} does not exist."
    end

    local_assets_path = Rails.root.join("public", ViteRuby.config.public_output_dir)

    Dir.glob("#{local_assets_path}/**/*").each do |file|
      next if File.directory?(file)

      key = file.sub("#{local_assets_path}/", "")
      obj = bucket.object(key)

      puts "Uploading #{file} to S3 bucket #{bucket_name} with key #{key}..."
      obj.upload_file(file)
    end

    puts "Vite assets successfully synced to S3!"
  end
end
