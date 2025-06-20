require 'csv'
require 'fileutils'

class BaseRepository
  def initialize(filename, headers:)
    @path    = filename
    @headers = headers  
    ensure_file_exists
  end

  def all_rows
    rows = []
    CSV.foreach(@path, headers: true, col_sep: ';') do |row|
      rows << row.to_hash.transform_keys(&:to_sym)
    end
    rows
  end

  def write_all_rows(rows)
    CSV.open(@path, 'w', write_headers: true, headers: @headers.map(&:to_s), col_sep: ';') do |csv|
      rows.each do |h|
        csv << @headers.map { |k| h[k].to_s }
      end
    end
  end

  def add_row(data)
    id = next_id
    data_with_id = data.merge(id: id)
    CSV.open(@path, 'a', col_sep: ';') do |csv|
      csv << @headers.map { |h| data_with_id[h].to_s }
    end
    id
  end

  def find_by_id(id)
    all_rows.find { |h| h[:id].to_i == id.to_i }
  end

  def delete_by_id(id)
    rows = all_rows.reject { |h| h[:id].to_i == id.to_i }
    write_all_rows(rows)
  end

  private

  def ensure_file_exists
    dirname = File.dirname(@path)
    FileUtils.mkdir_p(dirname) unless Dir.exist?(dirname)
    unless File.exist?(@path)
      CSV.open(@path, 'w', write_headers: true, headers: @headers.map(&:to_s), col_sep: ';') { |_csv| }
    end
  end

  def next_id
    last = all_rows.map { |h| h[:id].to_i }.max || 0
    last + 1
  end

  def update(id, attrs = {})
    updated_rows = all_rows.map do |row|
      if row[:id].to_i == id.to_i
        row.merge(attrs.transform_keys(&:to_sym))
      else
        row
      end
    end
    write_all_rows(updated_rows)
    find_by_id(id)
  end
end

