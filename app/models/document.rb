class Document < ActiveRecord::Base
  belongs_to :lesson

  has_attached_file :file
  validates_attachment_file_name :file, matches: [/zip\Z/,/doc\Z/,/png\Z/, /jpe?g\Z/, /txt\Z/]

end
