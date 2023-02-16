import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:interpretasi_editor/src/data/datasources/article_data_source.dart';
import 'package:interpretasi_editor/src/data/datasources/auth_data_source.dart';
import 'package:interpretasi_editor/src/data/datasources/category_remote_data_source.dart';
import 'package:interpretasi_editor/src/data/datasources/user_article_data_source.dart';
import 'package:interpretasi_editor/src/data/repositories/article_repository_impl.dart';
import 'package:interpretasi_editor/src/data/repositories/auth_repository_impl.dart';
import 'package:interpretasi_editor/src/data/repositories/category_repository_impl.dart';
import 'package:interpretasi_editor/src/data/repositories/user_article_repository_impl.dart';
import 'package:interpretasi_editor/src/domain/repositories/article_repository.dart';
import 'package:interpretasi_editor/src/domain/repositories/auth_repository.dart';
import 'package:interpretasi_editor/src/domain/repositories/category_repository.dart';
import 'package:interpretasi_editor/src/domain/repositories/user_article_repository.dart';
import 'package:interpretasi_editor/src/domain/usecases/change_to_moderated.dart';
import 'package:interpretasi_editor/src/domain/usecases/check_auth.dart';
import 'package:interpretasi_editor/src/domain/usecases/create_article.dart';
import 'package:interpretasi_editor/src/domain/usecases/delete_article.dart';
import 'package:interpretasi_editor/src/domain/usecases/get_article.dart';
import 'package:interpretasi_editor/src/domain/usecases/get_article_detail.dart';
import 'package:interpretasi_editor/src/domain/usecases/get_banned_article.dart';
import 'package:interpretasi_editor/src/domain/usecases/get_categories.dart';
import 'package:interpretasi_editor/src/domain/usecases/get_drafted_article.dart';
import 'package:interpretasi_editor/src/domain/usecases/get_moderated_article.dart';
import 'package:interpretasi_editor/src/domain/usecases/get_published_article.dart';
import 'package:interpretasi_editor/src/domain/usecases/get_rejected_article.dart';
import 'package:interpretasi_editor/src/domain/usecases/sign_in_with_email.dart';
import 'package:interpretasi_editor/src/domain/usecases/sign_out.dart';
import 'package:interpretasi_editor/src/domain/usecases/update_article.dart';
import 'package:interpretasi_editor/src/presentation/bloc/article_form/article_form_bloc.dart';
import 'package:interpretasi_editor/src/presentation/bloc/auth_watcher/auth_watcher_bloc.dart';
import 'package:interpretasi_editor/src/presentation/bloc/category_watcher/category_watcher_bloc.dart';
import 'package:interpretasi_editor/src/presentation/bloc/delete_article_actor/delete_article_actor_bloc.dart';
import 'package:interpretasi_editor/src/presentation/bloc/localization_watcher/localization_watcher_bloc.dart';
import 'package:interpretasi_editor/src/presentation/bloc/sign_in_with_email_form/sign_in_with_email_form_bloc.dart';
import 'package:interpretasi_editor/src/presentation/bloc/theme_watcher/theme_watcher_bloc.dart';
import 'package:interpretasi_editor/src/presentation/bloc/user_article_drafted_watcher/user_article_drafted_watcher_bloc.dart';
import 'package:interpretasi_editor/src/presentation/bloc/user_article_moderated_watcher/user_article_moderated_watcher_bloc.dart';

final locator = GetIt.instance;

void init() {
  /// List of [External Packages]
  ///
  ///
  final httpPackage = http.Client();
  locator.registerLazySingleton(
    () => httpPackage,
  );

  /// List of [Remote Data Source]
  ///
  ///
  final articleDataSource = ArticleDataSourceImpl(locator());
  locator.registerLazySingleton<ArticleDataSource>(
    () => articleDataSource,
  );

  final authDataSource = AuthDataSourceImpl(locator());
  locator.registerLazySingleton<AuthDataSource>(
    () => authDataSource,
  );

  final categoryDataSource = CategoryDataSourceImpl(locator());
  locator.registerLazySingleton<CategoryDataSource>(
    () => categoryDataSource,
  );

  final userArticleDataSource = UserArticleDataSourceImpl(locator());
  locator.registerLazySingleton<UserArticleDataSource>(
    () => userArticleDataSource,
  );

  /// List of [Repositories]
  ///
  ///
  final articleRepository = ArticleRepositoryImpl(locator());
  locator.registerLazySingleton<ArticleRepository>(
    () => articleRepository,
  );
  
  final authRepository = AuthRepositoryImpl(locator());
  locator.registerLazySingleton<AuthRepository>(
    () => authRepository,
  );
  
  final categoryRepository = CategoryRepositoryImpl(locator());
  locator.registerLazySingleton<CategoryRepository>(
    () => categoryRepository,
  );

  final userArticleRepository = UserArticleRepositoryImpl(locator());
  locator.registerLazySingleton<UserArticleRepository>(
    () => userArticleRepository,
  );

  /// List of [Usecases]
  ///
  ///
  final changeToModeratedUseCase = ChangeToModerated(locator());
  locator.registerLazySingleton(
    () => changeToModeratedUseCase,
  );
  final checkAuthUseCase = CheckAuth(locator());
  locator.registerLazySingleton(
    () => checkAuthUseCase,
  );
  final createArticleUseCase = CreateArticle(locator());
  locator.registerLazySingleton(
    () => createArticleUseCase,
  );
  final deleteArticleUseCase = DeleteArticle(locator());
  locator.registerLazySingleton(
    () => deleteArticleUseCase,
  );
  final getArticleDetailUseCase = GetArticleDetail(locator());
  locator.registerLazySingleton(
    () => getArticleDetailUseCase,
  );
  final getArticleUseCase = GetArticle(locator());
  locator.registerLazySingleton(
    () => getArticleUseCase,
  );
  final getBannedArticleUseCase = GetBannedArticle(locator());
  locator.registerLazySingleton(
    () => getBannedArticleUseCase,
  );
  final getCategoryUseCase = GetCategories(locator());
  locator.registerLazySingleton(
    () => getCategoryUseCase,
  );
  final getDraftedArticleUseCase = GetDraftedArticle(locator());
  locator.registerLazySingleton(
    () => getDraftedArticleUseCase,
  );
  final getModeratedArticleUseCase = GetModeratedArticle(locator());
  locator.registerLazySingleton(
    () => getModeratedArticleUseCase,
  );
  final getPublishedArticleUseCase = GetPublishedArticle(locator());
  locator.registerLazySingleton(
    () => getPublishedArticleUseCase,
  );
  final getRejectedArticleUseCase = GetRejectedArticle(locator());
  locator.registerLazySingleton(
    () => getRejectedArticleUseCase,
  );
  final signInWithEmailUseCase = SignInWithEmail(locator());
  locator.registerLazySingleton(
    () => signInWithEmailUseCase,
  );
  
  final signOutUseCase = SignOut(locator());
  locator.registerLazySingleton(
    () => signOutUseCase,
  );
  final updateArticleUseCase = UpdateArticle(locator());
  locator.registerLazySingleton(
    () => updateArticleUseCase,
  );

  /// List of [BLoCs]
  ///
  ///
  final articleFormBloc = ArticleFormBloc(
    create: locator(),
    update: locator(),
    articleDetail: locator(),
  );
  locator.registerLazySingleton(
    () => articleFormBloc,
  );

  final authWatcherBloc = AuthWatcherBloc(
    checkAuth: locator(),
    signOut: locator(),
  );
  locator.registerLazySingleton(
    () => authWatcherBloc,
  );

  final categoryWatcherBloc = CategoryWatcherBloc(locator());
  locator.registerLazySingleton(
    () => categoryWatcherBloc,
  );

  final deleteArticleActorBloc = DeleteArticleActorBloc(locator());
  locator.registerLazySingleton(
    () => deleteArticleActorBloc,
  );

  final localizationWatcherBloc = LocalizationWatcherBloc();
  locator.registerLazySingleton(
    () => localizationWatcherBloc,
  );

  final signInWithEmailFormBloc = SignInWithEmailFormBloc(locator());
  locator.registerLazySingleton(
    () => signInWithEmailFormBloc,
  );
  
  final themeWatcherBloc = ThemeWatcherBloc();
  locator.registerLazySingleton(
    () => themeWatcherBloc,
  );

  final userArticleDraftedBloc = UserArticleDraftedWatcherBloc(locator());
  locator.registerLazySingleton(
    () => userArticleDraftedBloc,
  );

  final userArticleModeratedBloc = UserArticleModeratedWatcherBloc(locator());
  locator.registerLazySingleton(
    () => userArticleModeratedBloc,
  );
}
