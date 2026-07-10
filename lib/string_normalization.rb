class String
  # Use NFC consistently for local paths and Cloud Storage object names.
  def normalized
    unicode_normalize(:nfc)
  end
end
