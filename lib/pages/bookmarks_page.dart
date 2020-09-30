import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_news_app/providers/user.dart';
import 'package:flutter_news_app/providers/articles.dart';

import 'package:flutter_news_app/widgets/article_list_item.dart';

import 'package:flutter_news_app/pages/details_page.dart';

class BookmarksPage extends StatelessWidget {
  void _showMessage(BuildContext context, String message) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: Duration(seconds: 3),
    ));
  }

  _deleteBookmark(BuildContext context, int id) {
    var userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.deleteBookmark(id);
    _showMessage(
      context,
      'Cet article a bien été supprimé de votre liste de signets!',
    );
  }

  void _readArticle(BuildContext context, int id) {
    Navigator.of(context).pushNamed(DetailsPage.routeName, arguments: id);
  }

  @override
  Widget build(BuildContext context) {
    var articlesProvider = Provider.of<ArticlesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.menu,
          ),
          onPressed: () {},
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            AppBar(
              elevation: 0,
              title: Text(
                'Filtrer les signets',
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.search,
                  ),
                  onPressed: () {},
                )
              ],
            ),
            Consumer<UserProvider>(
              builder: (_, userProvider, child) =>
                  userProvider.bookmarks != null &&
                          userProvider.bookmarks.length == 0
                      ? Container()
                      : ListView.builder(
                          shrinkWrap: true,
                          primary: false,
                          itemBuilder: (_, index) {
                            var article = articlesProvider.findById(
                              userProvider.bookmarks[index],
                            );
                            return Dismissible(
                              key: ValueKey(article.id),
                              direction: DismissDirection.endToStart,
                              onDismissed: (_) => _deleteBookmark(
                                context,
                                article.id,
                              ),
                              background: Container(
                                  color: Colors.red,
                                  child: Container(
                                    padding: EdgeInsets.only(right: 30),
                                    alignment: Alignment.centerRight,
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                  )),
                              child: ArticleListItem(
                                category: article.category,
                                id: article.id,
                                image: article.banner,
                                title: article.title,
                                onPress: (id) => _readArticle(context, id),
                                onLongPress: () {},
                                date: article.createdAt,
                              ),
                            );
                          },
                          itemCount: userProvider.bookmarks.length,
                        ),
            )
          ],
        ),
      ),
    );
  }
}
