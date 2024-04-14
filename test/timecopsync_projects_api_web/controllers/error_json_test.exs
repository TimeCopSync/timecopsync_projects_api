defmodule TimecopsyncProjectsApiWeb.ErrorJSONTest do
  use TimecopsyncProjectsApiWeb.ConnCase, async: true

  test "renders 404" do
    assert TimecopsyncProjectsApiWeb.ErrorJSON.render("404.json", %{}) == %{
             errors: %{detail: "Not Found"}
           }
  end

  test "renders 500" do
    assert TimecopsyncProjectsApiWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
