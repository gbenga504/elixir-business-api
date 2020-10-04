# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     BusiApi.Repo.insert!(%BusiApi.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias BusiApi.Directory
alias BusiApi.Directory.Business

business_names = ~w{Konga Jumia Zappos}
for business_name <- business_names do
  Directory.create_business(%Business{name: business_name, tag: "e-commerce", description: "Just another ecommerce store"})
end
