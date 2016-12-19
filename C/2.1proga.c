typedef struct Card Card;
struct Card {
	short tag, suit, rank;
	Card *link;
};

static Card *top;

void
faceup(Card *newcard)
{
	newcard->link = top;
	top = newcard;
	newcard->tag = 0;
}
