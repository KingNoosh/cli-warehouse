require 'minitest'
require "minitest/autorun"
require './app/simple_warehouse'

class TestSimpleWarehouse < MiniTest::Test
  def setup
    @simple_warehouse = SimpleWarehouse.new
  end

  def test_initialise_map_no_arguments
    out, err = capture_io do
      @simple_warehouse.send(:initialise_map, nil, nil)
    end
    assert_equal "Missing arguments width, height\n", out
  end

  def test_initialise_map_success
    out, err = capture_io do
      @simple_warehouse.send(:initialise_map, 10, 10)
    end
    assert_equal "Initialised map 10x10\n", out
  end

  def test_show_map_success
    out, err = capture_io do
      @simple_warehouse.send(:initialise_map, 10, 10)
      @simple_warehouse.send(:show_map)
    end
    assert_equal "Initialised map 10x10
##########
##########
##########
##########
##########
##########
##########
##########
##########
##########\n", out
  end

  def test_show_map_success_with_object
    out, err = capture_io do
      @simple_warehouse.send(:initialise_map, 10, 10)
      @simple_warehouse.send(:store_object, 0, 0, 2, 2, 'a')
      @simple_warehouse.send(:show_map)
    end
    assert_equal "Initialised map 10x10
Created object
aa########
aa########
##########
##########
##########
##########
##########
##########
##########
##########\n", out
  end

  def test_show_map_success_with_object_added_and_removed
    out, err = capture_io do
      @simple_warehouse.send(:initialise_map, 10, 10)
      @simple_warehouse.send(:store_object, 0, 0, 2, 2, 'a')
      @simple_warehouse.send(:show_map)
      @simple_warehouse.send(:remove_object, 1,1)
      @simple_warehouse.send(:show_map)
    end
    assert_equal "Initialised map 10x10
Created object
aa########
aa########
##########
##########
##########
##########
##########
##########
##########
##########
Deleted product at 1,1
##########
##########
##########
##########
##########
##########
##########
##########
##########
##########\n", out
  end

  def test_store_object_fail_no_arguments
    out, err = capture_io do
      @simple_warehouse.send(:initialise_map, 10, 10)
      @simple_warehouse.send(:store_object, nil, nil, nil, nil, nil)
    end
    assert_equal "Initialised map 10x10\nMissing arguments x, y, w, h, p\n", out
  end

  def test_store_object_fail_map_not_initialised
    out, err = capture_io do
      @simple_warehouse.send(:store_object, 0, 0, 2, 2, 'a')
    end
    assert_equal "Please initialise the map first by running `init w h`.\n", out
  end

  def test_store_object_fail_already_exists
    out, err = capture_io do
      @simple_warehouse.send(:initialise_map, 10, 10)
      @simple_warehouse.send(:store_object, 0, 0, 2, 2, 'a')
      @simple_warehouse.send(:store_object, 1, 1, 2, 2, 'b')
    end
    assert_equal "Initialised map 10x10\nCreated object\nSomething already is here\n", out
  end

  def test_store_object_fail_product_id_more_than_one_character
    out, err = capture_io do
      @simple_warehouse.send(:initialise_map, 10, 10)
      @simple_warehouse.send(:store_object, 0, 0, 2, 2, 'ab')
    end
    assert_equal "Initialised map 10x10\nProduct Id must be a single character\n", out
  end

  def test_store_object_fail_outside_map
    out, err = capture_io do
      @simple_warehouse.send(:initialise_map, 10, 10)
      @simple_warehouse.send(:store_object, 11, 11, 2, 2, 'a')
    end
    assert_equal "Initialised map 10x10\nThis position doesn't exist\n", out
  end

  def test_store_object_fail_too_big
    out, err = capture_io do
      @simple_warehouse.send(:initialise_map, 10, 10)
      @simple_warehouse.send(:store_object, 2, 2, 11, 11, 'a')
    end
    assert_equal "Initialised map 10x10\nNot enough space\n", out
  end

  def test_store_object_success
    out, err = capture_io do
      @simple_warehouse.send(:initialise_map, 10, 10)
      @simple_warehouse.send(:store_object, 0, 0, 2, 2, 'a')
    end
    assert_equal "Initialised map 10x10\nCreated object\n", out
  end

  def test_locate_object_fail_no_arguments
    out, err = capture_io do
      @simple_warehouse.send(:initialise_map, 10, 10)
      @simple_warehouse.send(:store_object, 0, 0, 2, 2, 'a')
      @simple_warehouse.send(:locate_objects, nil)
    end
    assert_equal "Initialised map 10x10\nCreated object\nMissing arguments product id\n", out
  end

  def test_locate_object_fail_none_exist
    out, err = capture_io do
      @simple_warehouse.send(:initialise_map, 10, 10)
      @simple_warehouse.send(:locate_objects, 'a')
    end
    assert_equal "Initialised map 10x10\nThere are no products with the id of a\n", out
  end

  def test_locate_object_success
    out, err = capture_io do
      @simple_warehouse.send(:initialise_map, 10, 10)
      @simple_warehouse.send(:store_object, 0, 0, 2, 2, 'a')
      @simple_warehouse.send(:locate_objects, 'a')
    end
    assert_equal "Initialised map 10x10
Created object
The locations of product id a are:
Width: 2, Height: 2 @ 0,0
", out
  end

  def test_remove_object_fail_no_arguments
    out, err = capture_io do
      @simple_warehouse.send(:initialise_map, 10, 10)
      @simple_warehouse.send(:store_object, 0, 0, 2, 2, 'a')
      @simple_warehouse.send(:remove_object, nil, nil)
    end
    assert_equal "Initialised map 10x10\nCreated object\nMissing arguments x, y\n", out
  end

  def test_remove_object_fail_no_object_exists
    out, err = capture_io do
      @simple_warehouse.send(:initialise_map, 10, 10)
      @simple_warehouse.send(:remove_object, 1, 1)
    end
    assert_equal "Initialised map 10x10\nProduct doesn't exist\n", out
  end

  def test_remove_object_success
    out, err = capture_io do
      @simple_warehouse.send(:initialise_map, 10, 10)
      @simple_warehouse.send(:store_object, 0, 0, 2, 2, 'a')
      @simple_warehouse.send(:remove_object, 1, 1)
    end
    assert_equal "Initialised map 10x10\nCreated object\nDeleted product at 1,1\n", out
  end

  def test_get_object_success
    out, err = capture_io do
      @simple_warehouse.send(:initialise_map, 10, 10)
      @simple_warehouse.send(:store_object, 0, 0, 2, 2, 'a')
    end

    assert_equal 0, @simple_warehouse.send(:get_object, 1, 1)
  end

  def test_get_object_fail_no_arguments
    out, err = capture_io do
      @simple_warehouse.send(:initialise_map, 10, 10)
      @simple_warehouse.send(:store_object, 0, 0, 2, 2, 'a')
      @simple_warehouse.send(:get_object, nil, nil)
    end

    assert_equal "Initialised map 10x10\nCreated object\nMissing arguments x, y\n", out
  end

  def test_get_object_fail_map_not_initialised
    out, err = capture_io do
      @simple_warehouse.send(:get_object, 1, 1)
    end

    assert_equal "Please initialise the map first by running `init w h`.\n", out
  end
end
