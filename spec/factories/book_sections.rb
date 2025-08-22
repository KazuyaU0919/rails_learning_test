FactoryBot.define do
  factory :book_section do
    book { nil }
    heading { "MyString" }
    content { "MyText" }
    is_free { false }
    position { 1 }
  end
end
