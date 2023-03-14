import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  Future<void> registerUser(
      {required String email, required String password}) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      emit(RegisterSucess());
    } on FirebaseAuthException catch (ex) {
      if (ex.code == 'weak-password') {
        emit(RegisterFailure(errMessge: 'The password provided is too weak.'));
      } else if (ex.code == 'email-already-in-use') {
        emit(RegisterFailure(
            errMessge: 'The account already exists for that email.'));
      }
    } catch (e) {
      emit(RegisterFailure(errMessge: 'There was an error please try again'));
    }
  }

  Future<void> loginUser(
      {required String email, required String password}) async {
    emit(LoginLoading());
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      emit(LoginSucess());
    } on FirebaseAuthException catch (ex) {
      if (ex.code == 'user-not-found') {
        emit(LoginFailure(errMessage: 'user not found'));
      } else if (ex.code == 'wrong-password') {
        emit(LoginFailure(errMessage: 'wrong password'));
      }
    } catch (e) {
      emit(LoginFailure(errMessage: 'Something went wrong'));
    }
  }
}
