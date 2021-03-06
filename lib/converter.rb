# frozen_string_literal:true

module CONVERTER
  # Docu
  class Converter
    def self.gpx_to_kml(gpx, output_path)
      return unless File.directory?(output_path) && gpx.is_a?(GPX::Gpx)
      return nil unless gpx.gpx?

      output_path = output_path[0..-2] if output_path[-1].eql?('/')
      kml = Nokogiri::XML::Builder.new do |xml|
        xml.kml('xmlns': 'http://www.opengis.net/kml/2.2', 'xmlns:gx': 'http://www.google.com/kml/ext/2.2',
                'xmlns:atom': 'http://www.w3.org/Atom') do
          xml.Document do
            if gpx.name.nil? || gpx.name.empty?
              xml.name(gpx.file_name[0..-5])
            else
              xml.name(gpx.name)
            end
            xml.visibility('1')
            xml.open('0')
            unless gpx.author.nil? || gpx.author.empty?
              xml['atom'].author do
                xml['atom'].name(gpx.author)
              end
            end
            xml['atom'].link(href: gpx.link) unless gpx.link.nil? || gpx.link.empty?
            kml_points(xml, gpx)
            kml_routes(xml, gpx)
            kml_tracks(xml, gpx)
          end
        end
      end
      name = if gpx.file_name.end_with?('.gpx') || gpx.file_name.end_with?('.xml')
               "#{output_path}/#{Time.now.strftime('%Y%m%d%H%M%S')}_#{gpx.file_name[0..-5]}.kml"
             else
               "#{output_path}/#{Time.now.strftime('%Y%m%d%H%M%S')}_#{gpx.file_name}.kml"
             end
      f = File.open(name.to_s, 'w')
      f.write(kml.to_xml)
      f.close
      name
    end

    def self.kml_to_gpx(kml, output_path)
      return nil unless File.directory?(output_path) && kml.is_a?(KML::Kml)
      return nil unless kml.kml?

      output_path = output_path[0..-2] if output_path[-1].eql?('/')
      gpx = Nokogiri::XML::Builder.new do |xml|
        xml.gpx('version': '1.1', 'creator': 'https://www.github.com/engim-eu/gpx_kml',
                'xmlns': 'https://www.topografix.com/GPX/1/1', 'xmlns:xsi': 'http://www.w3.org/2001/XMLSchema-instance') do
          xml.metadata do
            xml.name(kml.file_name[0..-5])
          end
          gpx_points(xml, kml)
          gpx_routes(xml, kml)
          gpx_tracks(xml, kml)
        end
      end
      name = if kml.file_name.end_with?('.kml') || kml.file_name.end_with?('.xml')
               "#{output_path}/#{Time.now.strftime('%Y%m%d%H%M%S')}_#{kml.file_name[0..-5]}.gpx"
             else
               "#{output_path}/#{Time.now.strftime('%Y%m%d%H%M%S')}_#{kml.file_name}.gpx"
             end
      f = File.open(name.to_s, 'w')
      f.write(gpx.to_xml)
      f.close
      name
    end

    def self.kml_routes(xml, gpx)
      if gpx.routes?
        gpx.routes.each do |r|
          xml.Placemark do
            xml.LinearRing do
              xml.extrude('0')
              xml.tassellate('0')
              xml.altitudeMode('clampToGroud')
              s = ''
              r.points.each do |p|
                s = if p.elevation.nil? || p.elevation.empty?
                      s + "#{p.longitude},#{p.latitude} "
                    else
                      s + "#{p.longitude},#{p.latitude},#{p.elevation} "
                    end
              end
              xml.coordinates(s[0..-2])
            end
          end
        end
      end
    end

    def self.kml_tracks(xml, gpx)
      if gpx.tracks?
        gpx.tracks.each do |t|
          xml.Placemark do
            xml.LineString do
              xml.extrude('0')
              xml.tassellate('0')
              xml.altitudeMode('clampToGroud')
              s = ''
              points = []
              t.segments.each do |sg|
                sg.points.each do |p|
                  points = points << p
                end
              end
              points.each do |p|
                next if p.nil?

                s = if p.elevation.nil? || p.elevation.empty?
                      s + "#{p.longitude},#{p.latitude} "
                    else
                      s + "#{p.longitude},#{p.latitude},#{p.elevation} "
                    end
              end
              xml.coordinates(s[0..-2])
            end
          end
        end
      end
    end

    def self.kml_points(xml, gpx)
      if gpx.points?
        gpx.points.each do |p|
          xml.Point do
            xml.extrude('0')
            xml.altitudeMode('clampToGroud')
            if p.elevation.nil? || p.elevation.empty?
              xml.coordinates("#{p.longitude},#{p.latitude}")
            else
              xml.coordinates("#{p.longitude},#{p.latitude},#{p.elevation}")
            end
          end
        end
      end
    end

    def self.gpx_points(xml, kml)
      if kml.points?
        kml.points.each do |p|
          next if p.nil?

          xml.wpt('lat': p.latitude.to_s, 'lon': p.longitude.to_s) do
            xml.ele(p.elevation.to_s) unless p.elevation.nil? || p.elevation.empty?
            xml.name(p.name) unless p.name.nil? || p.name.empty?
            xml.desc("author = #{p.author}") unless p.author.nil? || p.author.empty?
            xml.link('href': p.link) unless p.link.nil? || p.link.empty?
          end
        end
      end
    end

    def self.gpx_routes(xml, kml)
      if kml.routes?
        kml.routes.each do |r|
          next if r.nil?

          xml.rte do
            xml.name(r.name) unless r.name.nil? || r.name.empty?
            xml.desc("author= #{r.author}") unless r.author.nil? || r.author.empty?
            xml.link('href': r.link) unless r.link.nil? || r.link.empty?
            r.points.each do |p|
              next if p.nil?

              xml.rtept('lat': p.latitude.to_s, 'lon': p.longitude.to_s) do
                xml.ele(p.elevation.to_s) unless p.elevation.nil? || p.elevation.empty?
                xml.desc("author = #{p.author}") unless p.author.nil? || p.author.empty?
                xml.link('href': p.link) unless p.link.nil? || p.link.empty?
              end
            end
          end
        end
      end
    end

    def self.gpx_tracks(xml, kml)
      if kml.tracks?
        kml.tracks.each do |t|
          next if t.nil?

          xml.trk do
            xml.name(t.name) unless t.name.nil? || t.name.empty?
            xml.desc("author= #{t.author}") unless t.author.nil? || t.author.empty?
            xml.link('href': t.link) unless t.link.nil? || t.link.empty?
            xml.trkseg do
              t.points.each do |p|
                next if p.nil?

                xml.trkpt('lat': p.latitude.to_s, 'lon': p.longitude.to_s) do
                  xml.ele(p.elevation.to_s) unless p.elevation.nil? || p.elevation.empty?
                  xml.desc("author = #{p.author}") unless p.author.nil? || p.author.empty?
                  xml.link('href': p.link) unless p.link.nil? || p.link.empty?
                end
              end
            end
          end
        end
      end
    end
  end
end
