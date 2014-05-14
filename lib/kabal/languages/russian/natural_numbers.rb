module Kabal
  module RussianRules
    module NaturalNumbers

      def feminine_natural_number_name(number, fractional_part = false)
        @number = number
        @feminine_name = !fractional_part
        @fractional_part = fractional_part
        natural_number_name number
      end

      def natural_number_name(number)
        #FIXME switch case next lines
        return single(number, true) if number >= 0 and number <= 19
        return two_words(number, true) if number >= 20 and number <= 99
        return three_words(number, true) if number >= 100 and number <= 999
        ten_powers(number) if number >= 1000
      end

      def single(number, this_is_end = false)
        if @feminine_name
          @feminine_name = false
          return names["single_feminine"][count(number) % 10] if count(number) % 10 == 1 or count(number) % 10 == 2
        end
        if @fractional_part and this_is_end
          @fractional_part = false
          return names["single_feminine"][count(number) % 10] if count(number) % 10 == 1 or count(number) % 10 == 2
        end
        names["single"][number]
      end

      def two_words(number, this_is_end = false)
        return single(number, this_is_end) if number <= 19
        number_name = names["two_words"][number / 10]
        number_name += " " + single(number % 10, this_is_end) if (number % 10 != 0)
        number_name
      end

      def three_words(number, this_is_end = false)
        return two_words(number, this_is_end) if number / 100 == 0
        number_name = names["three_words"][number / 100]
        return number_name += " " + two_words(number % 100, this_is_end) if (number % 100 >= 20)
        return number_name += " " + single(number % 100, this_is_end) if (number % 100 != 0)
        number_name
      end

      def ten_powers(number)
        #FIXME find better way
        return names["ten_powers"][100] if number_is_google? number
        less_thousands number if number_is_thousands? number
        return @number_name if number_is_thousands? number
        create_number_name number
        ten_powers(number % (10 ** number_order(number)))
      end

      def create_number_name(number)
        if @number_name.nil?
          @number_name = count_name(number) + " " + Declinations.name_with_declination(names["ten_powers"][number_order(number)], count(number))
        elsif count(number) != 0
          @number_name += " " + count_name(number) + " " + Declinations.name_with_declination(names["ten_powers"][number_order(number)], count(number))
        end
      end

      def less_thousands(number)
        @number_name += " " + three_words(number % 1000, true) unless number == 0
      end

      def count_name(number)
        #FIXME number.to_S[-4] not good
        @feminine_name = (number.to_s[-4] == "1" or number.to_s[-4] == "2") and count(number) and count(number) / 10 != 1 and number_order(number) == 3
        three_words count(number)
      end

      def is_number_ten_powers?
        @number <= -1000 and @number >= 1000
      end
    end
  end
end
