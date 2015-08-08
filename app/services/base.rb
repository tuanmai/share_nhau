module Services
  class Base
    def assign_attributes(options = {})
      options.slice(*self.class::ATTRIBUTES).each do |key, value|
        send("#{key}=", value)
      end
    end
  end
end
