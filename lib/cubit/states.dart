abstract class AppStates {}

class AppInitial extends AppStates {}

class GeneralState extends AppStates {}

class AddCartItemState extends AppStates {}

class ChangeCartItemState extends AppStates {}

class SendOrderState extends AppStates {}

class ChangeFavState extends AppStates {}

class InitialStateLoading extends AppStates {}

class InitialStateDone extends AppStates {}

class CartItemsLoading extends AppStates {}

class CartStateDone extends AppStates {}

class CartItemsDone extends AppStates {}

class GetFireStateDone extends AppStates {}

class NotificationReceived extends AppStates {}
