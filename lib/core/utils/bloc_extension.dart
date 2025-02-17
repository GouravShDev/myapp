import 'package:bloc/bloc.dart';

extension CubitExt<T> on Cubit<T> {
  void safeEmit(T state) {
    if (!isClosed) {
      // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
      emit(state);
    }
  }
}
extension BlocExt<E,S> on Bloc<E, S>{
  void safeEmit(S state){
    if(!isClosed){
      // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
      emit(state);
    }
  }
}