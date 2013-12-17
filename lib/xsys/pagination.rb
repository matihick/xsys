module Xsys
  class Pagination
    attr_accessor :page_index, :page_size, :pages_count, :records_count, :total_records_count

    def initialize(attributes={})
      attributes.each do |k,v|
        self.send("#{k}=", v)
      end
    end
  end
end
