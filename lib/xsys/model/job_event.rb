module Xsys
  module Model
    class JobEvent
      def self.attr_list
        [:description, :created_at]
      end

      attr_reader *attr_list

      def initialize(attributes={})
        attributes.each do |k, v|
          if k.to_s == 'created_at'
            @created_at = Time.parse(v)
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
