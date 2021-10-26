module KML
  # Docu
  class Route
    def initialize(route)
      return unless route.is_a?(Nokogiri::XML::Element) && !route.xpath('self::xmlns:LinearRing').empty?

      @node = route
      @name = _name
      @points = _points
      @author = _author
      @link = _link
    end

    attr_reader :name, :points, :author, :link

    private

    def _name
      elem = @node.xpath('.')
      while elem.xpath('self::xmlns:kml').empty?
        elem = elem.xpath('..')
        return elem.xpath('./xmlns:name/text()').to_s unless elem.xpath('./xmlns:name').empty?
      end
      ''
    end

    def _points
      p = []
      points = @node.xpath('./xmlns:coordinates/text()').to_s
      array_points = points.split(' ')
      array_points.each_with_index do |ap, i|
        p[i] = KML::Point.new ap, self, @node
      end
      p
    end

    def _author
      elem = @node.xpath('.')
      while elem.xpath('self::xmlns:kml').empty?
        elem = elem.xpath('..')
        return elem.xpath('./atom:author/atom:name/text()').to_s unless elem.xpath('./atom:author').empty?
      end
      ''
    end

    def _link
      elem = @node.xpath('.')
      while elem.xpath('self::xmlns:kml').empty?
        elem = elem.xpath('..')
        return elem.xpath('./atom:link/@href').to_s unless elem.xpath('./atom:link').empty?
      end
      ''
    end
  end
end
