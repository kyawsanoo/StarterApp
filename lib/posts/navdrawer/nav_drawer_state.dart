// this is the state the user is expected to see
class NavDrawerState {
  final NavItem selectedItem;
  const NavDrawerState(this.selectedItem);
}

// helpful navigation pages, you can change
// them to support your pages
enum NavItem {
  page_one,
  page_two,
  page_three,
}