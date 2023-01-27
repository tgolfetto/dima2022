/*
ItemCategory: an enumeration representing the possible categories of an item
*/
enum ItemCategory {
  Men,
  Women,
  Kids,
  Accessories,
  Shoes,
  Outdoors,
  Tops,
  Bottoms,
  Dresses,
  Intimates,
  Swimwear,
  Outerwear,
  Activewear,
  Loungewear,
  Suits,
  Formal,
}

/*
Returns the ItemCategory value corresponding to the given string.
@param category the string to convert
@return the ItemCategory value corresponding to the given string
@throws Exception if the given string is not a valid ItemCategory value
@requires category != null
@ensures the returned value is equal to the ItemCategory value corresponding to the given string
*/
ItemCategory categoryFromString(String category) {
  switch (category) {
    case 'Men':
      return ItemCategory.Men;
    case 'Women':
      return ItemCategory.Women;
    case 'Kids':
      return ItemCategory.Kids;
    case 'Accessories':
      return ItemCategory.Accessories;
    case 'Shoes':
      return ItemCategory.Shoes;
    case 'Outdoors':
      return ItemCategory.Outdoors;
    case 'Tops':
      return ItemCategory.Tops;
    case 'Bottoms':
      return ItemCategory.Bottoms;
    case 'Dresses':
      return ItemCategory.Dresses;
    case 'Intimates':
      return ItemCategory.Intimates;
    case 'Swimwear':
      return ItemCategory.Swimwear;
    case 'Outerwear':
      return ItemCategory.Outerwear;
    case 'Activewear':
      return ItemCategory.Activewear;
    case 'Loungewear':
      return ItemCategory.Loungewear;
    case 'Suits':
      return ItemCategory.Suits;
    case 'Formal':
      return ItemCategory.Formal;
    default:
      throw Exception('Invalid category');
  }
}

String categoryToString(ItemCategory category) {
  return category.name[0] + category.name.substring(2);
}
