# Developer Guide

Step-by-step instructions for extending the starter template.

## Create a New Feature

```bash
mkdir -p lib/features/orders/{data/{datasources/{local,remote},models,repositories,mapper},domain/{entities,repositories,usecases},presentation/{bloc/{events,states},pages,widgets}}
```

### 1. Domain Layer

```dart
// domain/entities/order.dart
class Order {
  const Order({required this.id, required this.total});
  final String id;
  final double total;
}

// domain/repositories/order_repository.dart
abstract class OrderRepository {
  Future<Result<List<Order>>> getOrders();
}

// domain/usecases/get_orders_usecase.dart
class GetOrdersUseCase extends UseCase<List<Order>, NoParams> {
  GetOrdersUseCase(this._repository);
  final OrderRepository _repository;

  @override
  Future<Result<List<Order>>> call(NoParams params) =>
      _repository.getOrders();
}
```

### 2. Data Layer

```dart
// data/models/order_model.dart — JSON DTO
// data/datasources/remote/order_remote_data_source.dart — API calls
// data/repositories/order_repository_impl.dart — extends BaseRepository
```

### 3. Presentation Layer

```dart
// presentation/bloc/order_bloc.dart — extends BaseBloc
// presentation/pages/orders_page.dart — extends BaseScreen
```

### 4. Register Dependencies

Add to `lib/core/di/injection.dart`:

```dart
getIt.registerLazySingleton<OrderRemoteDataSource>(
  () => OrderRemoteDataSourceImpl(apiService: getIt()),
);
getIt.registerLazySingleton<OrderRepository>(
  () => OrderRepositoryImpl(remote: getIt(), cache: getIt()),
);
getIt.registerFactory(() => GetOrdersUseCase(getIt()));
getIt.registerFactory(() => OrderBloc(getOrders: getIt(), logger: getIt()));
```

### 5. Add Route

In `lib/config/router/route_constants.dart` and `app_router.dart`.

---

## Create a BLoC

```dart
class ProductBloc extends BaseBloc<ProductEvent, ProductState> {
  ProductBloc({required GetProductsUseCase useCase, required AppLogger logger})
      : _useCase = useCase,
        super(const ProductState.initial(), logger: logger) {
    on<LoadProducts>(_onLoad);
  }

  final GetProductsUseCase _useCase;

  Future<void> _onLoad(LoadProducts event, Emitter<ProductState> emit) async {
    emit(state.copyWith(status: ViewStatus.loading));
    final result = await _useCase(const NoParams());
    result.when(
      success: (products) => emit(state.copyWith(
        status: products.isEmpty ? ViewStatus.empty : ViewStatus.success,
        products: products,
      )),
      failure: (f) => emit(state.copyWith(status: ViewStatus.failure, failure: f)),
    );
  }
}
```

---

## Create a Repository

```dart
class ProductRepositoryImpl extends BaseRepository implements ProductRepository {
  ProductRepositoryImpl({
    required ProductRemoteDataSource remote,
    required CacheManager cache,
    required NetworkInfo networkInfo,
  })  : _remote = remote,
        _cache = cache,
        _networkInfo = networkInfo;

  @override
  Future<Result<List<Product>>> getProducts() async {
    if (await _networkInfo.isConnected) {
      return execute(() async {
        final models = await _remote.fetchProducts();
        await _cache.cacheData('products', {'items': models.map((e) => e.toJson()).toList()});
        return models.map((m) => m.toEntity()).toList();
      });
    }
    final cached = _cache.getCachedData('products');
    if (cached != null) {
      return Success(/* parse cached */);
    }
    return const FailureResult(NetworkFailure());
  }
}
```

---

## Add an API Endpoint

1. Add path to `ApiEndpoints` in `core/network/network_constants.dart`
2. Create remote data source method using `ApiService`
3. Map response with model class

---

## Add a Screen

```dart
class OrdersPage extends BaseScreen {
  const OrdersPage({super.key});

  @override
  Widget buildBody(BuildContext context) {
    return BlocBuilder<OrderBloc, OrderState>(
      builder: (context, state) {
        if (state.isLoading) return const AppLoadingIndicator();
        if (state.isFailure) return AppErrorView(message: state.failure!.message);
        return ListView.builder(/* ... */);
      },
    );
  }
}
```

---

## Add Theme Tokens

Edit files in `lib/core/theme/`:
- `app_colors.dart` — color palette
- `app_typography.dart` — text styles
- `app_spacing.dart` — spacing scale
- `app_radius.dart` — border radius values

---

## Add Assets

1. Place files in appropriate `assets/` subfolder
2. Register in `pubspec.yaml` under `flutter.assets`
3. Reference via `AssetImage('assets/images/logo.png')`

---

## Add Fonts

1. Add `.ttf`/`.otf` files to `assets/fonts/`
2. Register in `pubspec.yaml`:

```yaml
fonts:
  - family: MyFont
    fonts:
      - asset: assets/fonts/MyFont-Regular.ttf
```

3. Use in `app_typography.dart`

---

## Add Localization

1. Add keys to `lib/l10n/app_en.arb`
2. Add translations to `lib/l10n/app_hi.arb`
3. Run `flutter gen-l10n`
4. Use: `context.l10n.myKey` or `AppLocalizations.of(context)!.myKey`

---

## Add Routes

```dart
// route_constants.dart
static const orders = '/orders';

// app_router.dart
GoRoute(
  path: RouteConstants.orders,
  builder: (context, state) => BlocProvider(
    create: (_) => getIt<OrderBloc>()..add(const LoadProducts()),
    child: const OrdersPage(),
  ),
),
```

---

## Add Hive Box

1. Add box name to `HiveBoxes` in `storage_keys.dart`
2. Open in `HiveStorageService.init()`
3. Access via `getIt<LocalStorageService>()`

---

## Write Tests

```dart
// Unit test
test('returns success with valid data', () async {
  when(() => mockRepo.getOrders()).thenAnswer(
    (_) async => Success([Order(id: '1', total: 99.99)]),
  );
  final result = await useCase(const NoParams());
  expect(result.isSuccess, true);
});

// Bloc test
blocTest<OrderBloc, OrderState>(
  'emits loading then success',
  build: () => OrderBloc(useCase: mockUseCase, logger: mockLogger),
  act: (bloc) => bloc.add(const LoadProducts()),
  expect: () => [
    isA<OrderState>().having((s) => s.status, 'status', ViewStatus.loading),
    isA<OrderState>().having((s) => s.status, 'status', ViewStatus.success),
  ],
);
```

See [TESTING_GUIDE.md](TESTING_GUIDE.md) for full details.
