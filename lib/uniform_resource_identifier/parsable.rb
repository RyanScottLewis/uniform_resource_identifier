class UniformResourceIdentifier
  module Parsable
    def parse(input)
      input.is_a?(self) ? input : new(input)
    end
  end
end