module Xsys
  class Pagination
    def self.attr_list
      [:page_index, :page_size, :pages_count, :records_count, :total_records_count]
    end

    attr_reader *attr_list

    def initialize(attributes={})
      attributes.each do |k, v|
        self.send("#{k}=", v) if self.respond_to?(k)
      end
    end

    private

    attr_writer *attr_list
  end
end
