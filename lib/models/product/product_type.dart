enum ProductType {
  Clothing,
  Shoes,
  Accessories,
  Beauty,
  Home,
  Other,
}

/*
Returns the ProductType enum value corresponding to the given string.
@param type the string to get the corresponding ProductType enum value for
@return the ProductType enum value corresponding to the given string
@throws Exception if the given string does not correspond to a valid ProductType enum value
@ensures the returned ProductType enum value corresponds to the given string
*/
ProductType typeFromString(String type) {
  switch (type) {
    case 'Clothing':
      return ProductType.Clothing;
    case 'Shoes':
      return ProductType.Shoes;
    case 'Accessories':
      return ProductType.Accessories;
    case 'Beauty':
      return ProductType.Beauty;
    case 'Home':
      return ProductType.Home;
    case 'Other':
      return ProductType.Other;
    default:
      throw Exception('Invalid category');
  }
}
