module APICake::Mocks
  # This is a utility class to simulate API responses using www.mocky.io
  # Used by the Client mock and the base_spec files 
  class Mocky
    def [](label)
      labels[label]
    end

    def labels
      {
        html:      '58a3685129000090043e49f5',
        json:      '58a373b229000090043e4a17',
        csv:       '58a374a82900009a043e4a1c',
        not_found: '58a400ed29000020083e4aa8',
        array:     '58a7ff851400005314867232',
        non_array: '58a801201400005f14867234',
      }
    end
  end
end