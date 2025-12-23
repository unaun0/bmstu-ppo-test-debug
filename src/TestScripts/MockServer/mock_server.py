from fastapi import FastAPI, Query, HTTPException
from pydantic import BaseModel
from typing import List, Optional
from datetime import datetime, timedelta

app = FastAPI(title="Mock GNews API")

VALID_API_KEYS = ["test-key"]

class NewsSource(BaseModel):
    id: Optional[str] = None
    name: str
    url: Optional[str] = None

class Article(BaseModel):
    id: str
    title: str
    description: str
    content: str
    url: str
    image: Optional[str] = None
    publishedAt: datetime
    lang: str
    source: NewsSource

class Information(BaseModel):
    realTimeArticles: dict

class GNewsResponse(BaseModel):
    information: Information
    totalArticles: int
    articles: List[Article]

mock_articles = [
    Article(
        id=f"mock{id}",
        title=f"{topic_title} статья {id}",
        description=f"Описание {topic_title} статьи {id}",
        content=f"Контент {topic_title} статьи {id}",
        url=f"https://example.com/{topic_title.lower()}/article{id}",
        image=f"https://example.com/{topic_title.lower()}/image{id}.jpg",
        publishedAt=datetime.utcnow() - timedelta(days=id),
        lang="ru",
        source=NewsSource(id=f"{id}", name=f"MockNews{id}", url="https://example.com")
    )
    for id, topic_title in zip(range(1, 11),
                               ["Health", "Health", "Health", "Health", "Health",
                                "Sports", "Sports", "Sports", "Sports", "Sports"])
]

@app.get("/v4/top-headlines", response_model=GNewsResponse)
async def get_top_headlines(
    topic: str = Query("health", regex="^(health|sports)$"),
    lang: str = Query("ru"),
    max: int = Query(2, ge=1, le=100),
    apikey: str = Query(...),
    from_date: Optional[datetime] = Query(None, alias="from"),
    to_date: Optional[datetime] = Query(None, alias="to")
):
    if not apikey or apikey not in VALID_API_KEYS:
        raise HTTPException(status_code=400, detail=["You did not provide an API key."])
    
    filtered_articles = [
        article for article in mock_articles
        if (topic.lower() in article.title.lower()) and article.lang == lang
    ]
    if from_date:
        filtered_articles = [a for a in filtered_articles if a.publishedAt >= from_date]
    if to_date:
        filtered_articles = [a for a in filtered_articles if a.publishedAt <= to_date]

    articles = filtered_articles[:max]

    return GNewsResponse(
        information={
            "realTimeArticles": {
                "message": "Real-time news data is only available on paid plans. Free plan has a 12-hour delay. Upgrade your plan here to remove the delay: https://gnews.io/change-plan"
            }
        },
        totalArticles=len(filtered_articles),
        articles=articles
    )
