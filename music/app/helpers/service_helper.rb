module ServiceHelper
  def percent(numerator, denominator)
    sprintf('%.0f%%', numerator / denominator.to_f * 100)
  end

  def count_and_percent(numerator, denominator)
    "#{numerator} (#{percent(numerator, denominator)})"
  end
end
