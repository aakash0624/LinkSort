class ClickCountWorker
    include Sidekiq::Worker
    require "csv"
    def perform(url_id)
        @url = Url.find_by(id: url_id)
         @url.count += 1
        @url.save!
        csv = CSV.generate do |rows|
            rows << ["id", "count", "website_name"]
            Url.all.each do |link|
                row = [link.id]
                row << link.count
                row << link.website_name
                rows << row
            end
        end
        
        File.open("file.csv", 'a') {|f| f.write(csv) }
    end
end