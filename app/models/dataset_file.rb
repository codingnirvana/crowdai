class DatasetFile < ApplicationRecord
  has_paper_trail
  belongs_to :challenge
  has_many :dataset_file_downloads, dependent: :destroy

  validates :description,           presence: true
end
