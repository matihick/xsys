module Xsys
  module Model
    class BackgroundJob
      def self.attr_list
        [:code, :shop_code, :label, :arguments, :status, :processed_items
         :total_items, :observations, :started_at, :ended_at, :events]
      end

      attr_reader *attr_list

      def initialize(attributes={})
        attributes.each do |k, v|
          if k.to_s == 'events'
            @events = v.map { |x| JobEvent.new(x) }
          elsif k.to_s == 'started_at'
            @started_at = Time.parse(v)
          elsif k.to_s == 'ended_at'
            @ended_at = Time.parse(v)
          else
            self.send("#{k}=", v) if self.respond_to?(k)
          end
        end
      end

      private

      attr_writer *attr_list
    end
  end
end
