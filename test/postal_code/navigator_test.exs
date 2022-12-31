defmodule ElhexDelivery.PostalCode.NavigatorTest do
  use ExUnit.Case
  alias ElhexDelivery.PostalCode.Navigator
  doctest ElhexDelivery

  describe "get_distance format tests" do
    test "postal code strings" do
      distance = Navigator.get_distance("94062", "94104")

      assert is_float(distance)
    end

    test "postal code integers" do
      distance = Navigator.get_distance(94062, 94104)

      assert is_float(distance)
    end

    test "postal code mixed" do
      distance = Navigator.get_distance(94062, "94104")

      assert is_float(distance)
    end

    @tag :capture_log
    test "postal code unexpected format" do
      navigator_pid = Process.whereis(:postal_code_navigator)
      reference = Process.monitor(navigator_pid)

      catch_exit do
        distance = Navigator.get_distance("94062", 94104.456)
      end

      assert_received({:DOWN, ^reference, :process, ^navigator_pid, {%ArgumentError{}, _}})
    end
  end
end
