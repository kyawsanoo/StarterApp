import 'package:flutter_bloc/flutter_bloc.dart';

import 'navdrawer.dart';

class NavDrawerBloc extends Bloc<NavDrawerEvent, NavDrawerState> {

  NavDrawerBloc():super(NavDrawerState(NavItem.page_one));

  @override
  Stream<NavDrawerState> mapEventToState(NavDrawerEvent event) async* {
    if (event is NavigateTo) {
      if (event.destination != state.selectedItem) {
        yield NavDrawerState(event.destination);
      }
    }
  }
}
